{ stdenv, runCommand, writeText, writeScript, writeScriptBin, ruby, lib
, callPackage, defaultGemConfig, fetchurl, fetchgit, buildRubyGem , bundler_HEAD
, git
}@defs:

# This is a work-in-progress.
# The idea is that his will replace load-ruby-env.nix.

{ name, gemset, gemfile, lockfile, ruby ? defs.ruby, gemConfig ? defaultGemConfig
, enableParallelBuilding ? false # TODO: this might not work, given the env-var shinanigans.
, postInstall ? null
, documentation ? false
, meta ? {}
}@args:

let

  shellEscape = x: "'${lib.replaceChars ["'"] [("'\\'" + "'")] x}'";
  const = x: y: x;
  bundler = bundler_HEAD.override { inherit ruby; };
  inherit (builtins) attrValues;

  gemName = attrs: "${attrs.name}-${attrs.version}.gem";

  fetchers.path = attrs: attrs.source.path;
  fetchers.gem = attrs: fetchurl {
    url = "${attrs.source.source or "https://rubygems.org"}/downloads/${gemName attrs}";
    inherit (attrs.source) sha256;
  };
  fetchers.git = attrs: fetchgit {
    inherit (attrs.source) url rev sha256 fetchSubmodules;
    leaveDotGit = true;
  };

  applySrc = attrs:
    attrs // {
      src = (fetchers."${attrs.source.type}" attrs);
    };

  applyGemConfigs = attrs:
    if gemConfig ? "${attrs.name}"
    then attrs // gemConfig."${attrs.name}" attrs
    else attrs;

  needsPatch = attrs:
    (attrs ? patches) || (attrs ? prePatch) || (attrs ? postPatch);

  # patch a gem or source tree.
  # for gems, the gem is unpacked, patched, and then repacked.
  # see: https://github.com/fedora-ruby/gem-patch/blob/master/lib/rubygems/patcher.rb
  applyPatches = attrs:
    if !needsPatch attrs
    then attrs
    else attrs // { src =
      stdenv.mkDerivation {
        name = gemName attrs;
        phases = [ "unpackPhase" "patchPhase" "installPhase" ];
        buildInputs = [ ruby ] ++ attrs.buildInputs or [];
        patches = attrs.patches or [ ];
        prePatch = attrs.prePatch or "true";
        postPatch = attrs.postPatch or "true";
        unpackPhase = ''
          runHook preUnpack

          if [[ -f ${attrs.src} ]]; then
            isGem=1
            # we won't know the name of the directory that RubyGems creates,
            # so we'll just use a glob to find it and move it over.
            gem unpack ${attrs.src} --target=container
            cp -r container/* contents
            rm -r container
          else
            cp -r ${attrs.src} contents
            chmod -R +w contents
          fi

          cd contents
          runHook postUnpack
        '';
        installPhase = ''
          runHook preInstall

          if [[ -n "$isGem" ]]; then
            ${writeScript "repack.rb" ''
              #!${ruby}/bin/ruby
              require 'rubygems'
              require 'rubygems/package'
              require 'fileutils'

              if defined?(Encoding.default_internal)
                Encoding.default_internal = Encoding::UTF_8
                Encoding.default_external = Encoding::UTF_8
              end

              if Gem::VERSION < '2.0'
                load "${./package-1.8.rb}"
              end

              out = ENV['out']
              files = Dir['**/{.[^\.]*,*}']

              package = Gem::Package.new("${attrs.src}")
              patched_package = Gem::Package.new(package.spec.file_name)
              patched_package.spec = package.spec.clone
              patched_package.spec.files = files

              patched_package.build(false)

              FileUtils.cp(patched_package.spec.file_name, out)
            ''}
          else
            cp -r . $out
          fi

          runHook postInstall
        '';
      };
    };

  instantiate = (attrs:
    applyPatches (applyGemConfigs (applySrc attrs))
  );

  instantiated = lib.flip lib.mapAttrs (import gemset) (name: attrs:
    instantiate (attrs // { inherit name; })
  );

  needsPreInstall = attrs:
    (attrs ? preInstall) || (attrs ? buildInputs) || (attrs ? nativeBuildInputs);

  # TODO: support cross compilation? look at stdenv/generic/default.nix.
  runPreInstallers = lib.fold (next: acc:
    if !needsPreInstall next
    then acc
    else acc + ''
      ${writeScript "${next.name}-pre-install" ''
        #!${stdenv.shell}

        export nativeBuildInputs="${toString ((next.nativeBuildInputs or []) ++ (next.buildInputs or []))}"

        source ${stdenv}/setup

        header "running pre-install script for ${next.name}"

        ${next.preInstall or ""}

        ${ruby}/bin/ruby -e 'print ENV.inspect' > env/${next.name}

        stopNest
      ''}
    ''
  ) "" (attrValues instantiated);

  # copy *.gem to ./gems
  copyGems = lib.fold (next: acc:
    if next.source.type == "gem"
    then acc + "cp ${next.src} gems/${gemName next}\n"
    else acc
  ) "" (attrValues instantiated);

  runRuby = name: env: command:
    runCommand name env ''
      ${ruby}/bin/ruby ${writeText name command}
    '';

  # TODO: include json_pure, so the version of ruby doesn't matter.
  # not all rubies have support for JSON built-in,
  # so we'll convert JSON to ruby expressions.
  json2rb = writeScript "json2rb" ''
    #!${ruby}/bin/ruby
    begin
      require 'json'
    rescue LoadError => ex
      require 'json_pure'
    end

    puts JSON.parse(STDIN.read).inspect
  '';

  # dump the instantiated gemset as a ruby expression.
  serializedGemset = runCommand "gemset.rb" { json = builtins.toJSON instantiated; } ''
    printf '%s' "$json" | ${json2rb} > $out
  '';

  # this is a mapping from a source type and identifier (uri/path/etc)
  # to the pure store path.
  # we'll use this from the patched bundler to make fetching sources pure.
  sources = runRuby "sources.rb" { gemset = serializedGemset; } ''
    out    = ENV['out']
    gemset = eval(File.read(ENV['gemset']))

    sources = {
      "git"  => { },
      "path" => { },
      "gem"  => { },
      "svn"  => { }
    }

    gemset.each_value do |spec|
      type = spec["source"]["type"]
      val = spec["src"]
      key =
        case type
        when "gem"
          spec["name"]
        when "git"
          spec["source"]["url"]
        when "path"
          spec["source"]["originalPath"]
        when "svn"
          nil # TODO
        end

      sources[type][key] = val if key
    end

    File.open(out, "wb") do |f|
      f.print sources.inspect
    end
  '';

  # rewrite PATH sources to point into the nix store.
  purifiedLockfile = runRuby "purifiedLockfile" {} ''
    out     = ENV['out']
    sources = eval(File.read("${sources}"))
    paths   = sources["path"]

    lockfile = File.read("${lockfile}")

    paths.each_pair do |impure, pure|
      lockfile.gsub!(/^  remote: #{Regexp.escape(impure)}/, "  remote: #{pure}")
    end

    File.open(out, "wb") do |f|
      f.print lockfile
    end
  '';

  needsBuildFlags = attrs: attrs ? buildFlags;

  mkBuildFlags = spec:
    "export BUNDLE_BUILD__${lib.toUpper spec.name}='${lib.concatStringsSep " " (map shellEscape spec.buildFlags)}'";

  allBuildFlags =
    lib.concatStringsSep "\n"
      (map mkBuildFlags
        (lib.filter needsBuildFlags (attrValues instantiated)));

in

stdenv.mkDerivation {
  inherit name;

  buildInputs = [
    ruby
    bundler
    git
  ];

  phases = [ "installPhase" "fixupPhase" ];

  outputs = [
    "out"    # the installed libs/bins
    "bundle" # supporting files for bundler
  ];

  installPhase = ''
    mkdir -p $bundle
    export BUNDLE_GEMFILE=$bundle/Gemfile
    cp ${gemfile} $BUNDLE_GEMFILE
    cp ${purifiedLockfile} $BUNDLE_GEMFILE.lock

    export NIX_GEM_SOURCES=${sources}
    export NIX_BUNDLER_GEMPATH=${bundler}/${ruby.gemPath}

    export GEM_HOME=$out/${ruby.gemPath}
    export GEM_PATH=$NIX_BUNDLER_GEMPATH:$GEM_HOME
    mkdir -p $GEM_HOME

    ${allBuildFlags}

    mkdir gems
    cp ${bundler}/${bundler.ruby.gemPath}/cache/bundler-*.gem gems
    ${copyGems}

    ${lib.optionalString (!documentation) ''
      mkdir home
      HOME="$(pwd -P)/home"
      echo "gem: --no-rdoc --no-ri" > $HOME/.gemrc
    ''}

    mkdir env
    ${runPreInstallers}

    mkdir $out/bin
    cp ${./monkey_patches.rb} monkey_patches.rb
    export RUBYOPT="-rmonkey_patches.rb -I $(pwd -P)"
    bundler install --frozen --binstubs ${lib.optionalString enableParallelBuilding "--jobs $NIX_BUILD_CORES"}
    RUBYOPT=""

    runHook postInstall
  '';

  inherit postInstall;

  passthru = {
    inherit ruby;
    inherit bundler;
  };

  inherit meta;
}
