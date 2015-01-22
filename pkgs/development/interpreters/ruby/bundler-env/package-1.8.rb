require 'rubygems/installer'
require 'rubygems/builder'

# Simulate RubyGems 2.0 behavior.

module Gem::Package
  def self.new(gem)
    @gem = gem
    self
  end

  def self.extract_files(dir)
    installer = Gem::Installer.new @gem
    installer.unpack(dir)
  end

  def self.build(skip_validation=false)
    builder = Gem::Builder.new(spec)
    builder.build
  end

  def self.spec=(spec)
    @spec = spec
  end

  def self.spec
    @spec ||= Gem::Installer.new(@gem).spec
  end
end
