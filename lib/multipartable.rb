require 'parts'
module Multipartable      
    DEFAULT_BOUNDARY = "-----------RubyMultipartPost"
    def initialize(path, params, headers={}, boundary = DEFAULT_BOUNDARY)
      super(path, headers)
      parts = params.map {|k,v| Parts::Part.new(boundary, k, v)}
      parts << Parts::EpiloguePart.new(boundary)
      ios = parts.map{|p| p.to_io}
      self.set_content_type("multipart/form-data", { "boundary" => boundary })

      self.content_length = parts.inject(0) {|sum,i| sum + i.length } 
      self.content_length += 2 if params[:"track[artwork_data]"] # This corrects a bug when uploading a sound file and artwork to Soundcloud.  

      self.body_stream = CompositeReadIO.new(*ios)
  end
end
