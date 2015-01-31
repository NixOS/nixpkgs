require 'bundler'

# Undo the RUBYOPT trickery.
opt = ENV['RUBYOPT'].dup
opt.gsub!(/-rmonkey_patches.rb -I [^ ]*/, '')
ENV['RUBYOPT'] = opt

Bundler.module_eval do
  class << self
    # mappings from original uris to store paths.
    def nix_gem_sources
      @nix_gem_sources ||=
        begin
          src = ENV['NIX_GEM_SOURCES']
          eval(Bundler.read_file(src))
        end
    end

    # extract the gemspecs from the gems pulled from Rubygems.
    def nix_gemspecs
      @nix_gemspecs ||= Dir.glob("gems/*.gem").map do |path|
        Bundler.rubygems.spec_from_gem(path)
      end
    end

    # swap out ENV
    def nix_with_env(env, &block)
      if env
        old_env = ENV.to_hash
        begin
          ENV.replace(env)
          block.call
        ensure
          ENV.replace(old_env)
        end
      else
        block.call
      end
    end

    # map a git uri to a fetchgit store path.
    def nix_git(uri)
      Pathname.new(nix_gem_sources["git"][uri])
    end
  end
end

Bundler::Source::Git::GitProxy.class_eval do
  def checkout
    unless path.exist?
      FileUtils.mkdir_p(path.dirname)
      FileUtils.cp_r(Bundler.nix_git(@uri).join(".git"), path)
      system("chmod -R +w #{path}")
    end
  end

  def copy_to(destination, submodules=false)
    unless File.exist?(destination.join(".git"))
      FileUtils.mkdir_p(destination.dirname)
      FileUtils.cp_r(Bundler.nix_git(@uri), destination)
      system("chmod -R +w #{destination}")
    end
  end
end

Bundler::Fetcher.class_eval do
  def use_api
    true
  end

  def fetch_dependency_remote_specs(gem_names)
    Bundler.ui.debug "Query Gemcutter Dependency Endpoint API: #{gem_names.join(',')}"
    deps_list = []

    spec_list = gem_names.map do |name|
      spec = Bundler.nix_gemspecs.detect {|spec| spec.name == name }
      dependencies = spec.dependencies.
        select {|dep| dep.type != :development}.
        map do |dep|
          deps_list << dep.name
          dep
        end

      [spec.name, spec.version, spec.platform, dependencies]
    end

    [spec_list, deps_list.uniq]
  end
end

Bundler::Source::Rubygems.class_eval do
  # We copy all gems into $PWD/gems, and this allows RubyGems to find those
  # gems during installation.
  def fetchers
    @fetchers ||= [
      Bundler::Fetcher.new(URI.parse("file://#{File.expand_path(Dir.pwd)}"))
    ]
  end

  # Look-up gems that were originally from RubyGems.
  def remote_specs
    @remote_specs ||=
      begin
        lockfile = Bundler::LockfileParser.new(Bundler.read_file(Bundler.default_lockfile))
        gem_names = lockfile.specs.
          select {|spec| spec.source.is_a?(Bundler::Source::Rubygems)}.
          map {|spec| spec.name}
        idx = Bundler::Index.new
        api_fetchers.each do |f|
          Bundler.ui.info "Fetching source index from #{f.uri}"
          idx.use f.specs(gem_names, self)
        end
        idx
      end
  end
end

Bundler::Installer.class_eval do

  # WHY:
  # This allows us to provide a typical Nix experience, where
  # `buildInputs` and/or `preInstall` may set up the $PATH and other env-vars
  # as needed. By swapping out the environment per install, we can have finer
  # grained control than we would have otherwise.
  #
  # HOW:
  # This is a wrapper around the original `install_gem_from_spec`.
  # We expect that a "pre-installer" might exist at `pre-installers/<gem-name>`,
  # and if it does, we execute it.
  # The pre-installer is expected to dump its environment variables as a Ruby
  # hash to `env/<gem-name>`.
  # We then swap out the environment for the duration of the install,
  # and then set it back to what it was originally.
  alias original_install_gem_from_spec install_gem_from_spec
  def install_gem_from_spec(spec, standalone = false, worker = 0)
    env_dump = "env/#{spec.name}"
    if File.exist?(env_dump)
      env = eval(Bundler.read_file(env_dump))
      unless env
        Bundler.ui.error "The environment variables for #{spec.name} could not be loaded!"
        exit 1
      end
      Bundler.nix_with_env(env) do
        original_install_gem_from_spec(spec, standalone, worker)
      end
    else
      original_install_gem_from_spec(spec, standalone, worker)
    end
  end

  def generate_bundler_executable_stubs(spec, options = {})
    return if spec.executables.empty?

    out = ENV['out']

    spec.executables.each do |executable|
      next if executable == "bundle" || executable == "bundler"

      binstub_path = "#{out}/bin/#{executable}"

      File.open(binstub_path, 'w', 0777 & ~File.umask) do |f|
        f.print <<-TEXT
#!#{RbConfig.ruby}

old_gemfile  = ENV["BUNDLE_GEMFILE"]
old_gem_home = ENV["GEM_HOME"]
old_gem_path = ENV["GEM_PATH"]

ENV["BUNDLE_GEMFILE"] =
  "#{ENV["BUNDLE_GEMFILE"]}"
ENV["GEM_HOME"] =
  "#{ENV["GEM_HOME"]}"
ENV["GEM_PATH"] =
  "#{ENV["NIX_BUNDLER_GEMPATH"]}:\#{ENV["GEM_HOME"]}\#{old_gem_path ? ":\#{old_gem_path}" : ""}}"

require 'rubygems'
require 'bundler/setup'

ENV["BUNDLE_GEMFILE"] = old_gemfile
ENV["GEM_HOME"]       = old_gem_home
ENV["GEM_PATH"]       = old_gem_path

load Gem.bin_path('#{spec.name}', '#{executable}')
TEXT
      end
    end
  end
end

Gem::Installer.class_eval do
  # Make the wrappers automagically use bundler.
  #
  # Stage 1.
  #   Set $BUNDLE_GEMFILE so bundler knows what gems to load.
  #   Set $GEM_HOME to the installed gems, because bundler looks there for
  #     non-Rubygems installed gems (e.g. git/svn/path sources).
  #   Set $GEM_PATH to include both bundler and installed gems.
  #
  # Stage 2.
  #   Setup bundler, locking down the gem versions.
  #
  # Stage 3.
  #   Reset $BUNDLE_GEMFILE, $GEM_HOME, $GEM_PATH.
  #
  # Stage 4.
  #   Run the actual executable.
  def app_script_text(bin_file_name)
    return <<-TEXT
#!#{RbConfig.ruby}
#
# This file was generated by Nix's RubyGems.
#
# The application '#{spec.name}' is installed as part of a gem, and
# this file is here to facilitate running it.
#

old_gemfile  = ENV["BUNDLE_GEMFILE"]
old_gem_home = ENV["GEM_HOME"]
old_gem_path = ENV["GEM_PATH"]

ENV["BUNDLE_GEMFILE"] =
  "#{ENV["BUNDLE_GEMFILE"]}"
ENV["GEM_HOME"] =
  "#{ENV["GEM_HOME"]}"
ENV["GEM_PATH"] =
  "#{ENV["NIX_BUNDLER_GEMPATH"]}:\#{ENV["GEM_HOME"]}\#{old_gem_path ? ":\#{old_gem_path}" : ""}}"

require 'rubygems'
require 'bundler/setup'

ENV["BUNDLE_GEMFILE"] = old_gemfile
ENV["GEM_HOME"]       = old_gem_home
ENV["GEM_PATH"]       = old_gem_path

load Gem.bin_path('#{spec.name}', '#{bin_file_name}')
TEXT
  end
end
