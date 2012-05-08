
# CobwebLinks processes links to determine whether they are internal or external links
class CobwebLinks
  
  # Initalise's internal and external patterns and sets up regular expressions
  def initialize(options={})
    @options = options
    
    raise InternalUrlsMissingError, ":internal_urls is required" unless @options.has_key? :internal_urls
    raise InvalidUrlsError, ":internal_urls must be an array" unless @options[:internal_urls].kind_of? Array
    raise InvalidUrlsError, ":external_urls must be an array" unless !@options.has_key?(:external_urls) || @options[:external_urls].kind_of?(Array)
    @options[:external_urls] = [] unless @options.has_key? :external_urls
    @options[:debug] = false unless @options.has_key? :debug
    
    @internal_patterns = @options[:internal_urls].map{|pattern| Regexp.new("^#{escape_pattern_for_regex(pattern)}")}
    @external_patterns = @options[:external_urls].map{|pattern| Regexp.new("^#{escape_pattern_for_regex(pattern)}")}
    
  end
  
  # Returns true if the link is matched to an internal_url and not matched to an external_url
  def internal?(link)
    if @options[:debug]
      puts "--------------------------------"
      puts "Link: #{link}"
      puts "Internal matches"
      ap @internal_patterns.select{|pattern| link.match(pattern)}
      puts "External matches"
      ap @external_patterns.select{|pattern| link.match(pattern)}
    end
    !@internal_patterns.select{|pattern| link.match(pattern)}.empty? && @external_patterns.select{|pattern| link.match(pattern)}.empty?
  end
  
  # Returns true if the link is matched to an external_url or not matched to an internal_url
  def external?(link)
    if @options[:debug]
      puts "--------------------------------"
      puts "Link: #{link}"
      puts "Internal matches"
      ap @internal_patterns.select{|pattern| link.match(pattern)}
      puts "External matches"
      ap @external_patterns.select{|pattern| link.match(pattern)}
    end
    @internal_patterns.select{|pattern| link.match(pattern)}.empty? || !@external_patterns.select{|pattern| link.match(pattern)}.empty?
  end
  
  private
  # escapes characters with meaning in regular expressions and adds wildcard expression
  def escape_pattern_for_regex(pattern)
    pattern = pattern.gsub(".", "\\.")
    pattern = pattern.gsub("?", "\\?")
    pattern = pattern.gsub("*", ".*?")
    ap pattern if @options[:debug]
    pattern
  end
end

# Exception raised for :internal_urls missing from CobwebLinks
class InternalUrlsMissingError < Exception
end  
# Exception raised for :internal_urls being invalid from CobwebLinks
class InvalidUrlsError < Exception
end

