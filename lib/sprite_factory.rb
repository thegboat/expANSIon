require_relative 'sprite'
require 'yaml'
require 'active_support/inflector'

class SpriteFactory
  attr_accessor :klasses


  def initialize(args)
    @klasses = {}
    objs = YAML.load_file(args[:yaml]) if args[:yaml]
    objs = args[:objects] if args[:objects]
    manufactur_classes(objs) if objs
  end

  def manufactur_classes(objs)
    objs.each do |obj, properties|
      klass = Object.const_set(obj.to_s.camelize, Class.new(Sprite))
      klass.send(:define_method, :defaults) do
        super().merge(properties)
      end
      @klasses[obj.to_sym] = klass
    end
  end

  def sprite_sheet
    3.times do 
      klasses.values.each do |klass|
        3.times { print klass.new.draw }
      end
      puts
    end
  end

end
