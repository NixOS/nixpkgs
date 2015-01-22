# See: https://github.com/cowboyd/libv8/pull/161

require 'yaml'
require 'pathname'
require File.expand_path '../paths', __FILE__

module Libv8
  class Location
    def install!
      File.open(Pathname(__FILE__).dirname.join('.location.yml'), "w") do |f|
        f.write self.to_yaml
      end
      return 0
    end

    def self.load!
      File.open(Pathname(__FILE__).dirname.join('.location.yml')) do |f|
        YAML.load f
      end
    end

    class Vendor < Location
      def install!
        require File.expand_path '../builder', __FILE__
        builder = Libv8::Builder.new
        exit_status = builder.build_libv8!
        super if exit_status == 0
        verify_installation!
        return exit_status
      end
      def configure(context = MkmfContext.new)
        context.incflags.insert 0, Libv8::Paths.include_paths.map{|p| "-I#{p}"}.join(" ")  + " "
        context.ldflags.insert 0, Libv8::Paths.object_paths.join(" ") + " "
      end

      def verify_installation!
        Libv8::Paths.object_paths.each do |p|
          fail ArchiveNotFound, p unless File.exist? p
        end
      end

      class ArchiveNotFound < StandardError
        def initialize(filename)
          super "libv8 did not install properly, expected binary v8 archive '#{filename}'to exist, but it was not found"
        end
      end
    end

    class System < Location
      def configure(context = MkmfContext.new)
        context.send(:dir_config, 'v8')
        context.send(:find_header, 'v8.h') or fail NotFoundError
        context.send(:have_library, 'v8') or fail NotFoundError
      end

      class NotFoundError < StandardError
        def initialize(*args)
          super(<<-EOS)
You have chosen to use the version of V8 found on your system
and *not* the one that is bundle with the libv8 rubygem. However,
it could not be located. please make sure you have a version of
v8 that is compatible with #{Libv8::VERSION} installed. You may
need to special --with-v8-dir options if it is in a non-standard
location

thanks,
The Mgmt

EOS
        end
      end
    end

    class MkmfContext
      def incflags
        $INCFLAGS
      end

      def ldflags
        $LDFLAGS
      end
    end
  end
end
