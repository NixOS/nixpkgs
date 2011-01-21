{stdenv, fetchurl, writeScript, makeWrapper, rubygems, ruby,
ncurses, xapianBindings, sqlite, libxml2, libxslt, libffi, zlib, libuuid}:

let
  gemsGenerated = (import ./gems-generated.nix) gemsWithVersions;
  patchUsrBinEnv = writeScript "path-usr-bin-env" ''
    #!/bin/sh
    set -x
    echo "==================="
    find "$1" -type f -name "*.rb" | xargs sed -i "s@/usr/bin/env@$(type -p env)@g"
    find "$1" -type f -name "*.mk" | xargs sed -i "s@/usr/bin/env@$(type -p env)@g"
  '';
  patches = {
    sup = {
      buildInputs = [ ncurses xapianBindings gems.ncursesw ];
    };
    sqlite3_ruby = { propagatedBuildInputs = [ sqlite ]; };
    rails = {
      gemFlags = "--no-ri --no-rdoc";
      propagatedBuildInputs = [ gems.mime_types gems.rake ];
    };
    ncurses = { buildInputs = [ ncurses ]; };
    ncursesw = { buildInputs = [ ncurses ]; };
    nokogiri = {
      buildFlags=["--with-xml2-dir=${libxml2} --with-xml2-include=${libxml2}/include/libxml2"
                  "--with-xslt-dir=${libxslt}" ];
    };

    ffi = {
      postUnpack = "onetuh";
      propagatedBuildInputs = [ gems.rake ];
      buildFlags=["--with-ffi-dir=${libffi}"];
      NIX_POST_EXTRACT_FILES_HOOK = patchUsrBinEnv;
    };

    xrefresh_server =
    let patch = fetchurl {
        url = "http://mawercer.de/~nix/xrefresh.diff.gz";
        sha256 = "1f7bnmn1pgkmkml0ms15m5lx880hq2sxy7vsddb3sbzm7n1yyicq";
      };
    in {
      propagatedBuildInputs = [ gems.rb_inotify ];

      # monitor implementation for Linux
      postInstall = ''
        cd $out/${ruby.gemPath}/gems/*
        zcat ${patch} | patch -p 1
      '';
    };

    xapian_full = {
      buildInputs = [ gems.rake zlib libuuid ];
      gemFlags = "--no-rdoc --no-ri";
    };
  };
  gemDefaults = { name, basename, requiredGems, sha256, meta }:
    {
      buildInputs = [rubygems ruby makeWrapper];
      unpackPhase = ":";
      configurePhase=":";
      bulidPhase=":";

      src = fetchurl {
        url = "http://rubygems.org/downloads/${name}.gem";
        inherit sha256;
      };

      name = "ruby-${name}";

      propagatedBuildInputs = requiredGems;
      inherit meta;

      installPhase = ''
        export HOME=$TMP/home; mkdir -pv "$HOME"

        gem install -V --ignore-dependencies \
        -i "$out/${ruby.gemPath}" -n "$out/bin" "$src" $gemFlags -- $buildFlags
        rm -frv $out/${ruby.gemPath}/cache # don't keep the .gem file here

        addToSearchPath GEM_PATH $out/${ruby.gemPath}

        for prog in $out/bin/*; do
          wrapProgram "$prog" \
            --prefix GEM_PATH : "$GEM_PATH" \
            --prefix RUBYLIB : "${rubygems}/lib" \
            --set RUBYOPT 'rubygems'
        done

        for prog in $out/gems/*/bin/*; do
          [[ -e "$out/bin/$(basename $prog)" ]]
        done

        runHook postInstall
      '';
    };
  gem = aName: a@{ name, basename, requiredGems, sha256, meta }:
    stdenv.mkDerivation (removeAttrs (stdenv.lib.mergeAttrsByFuncDefaults
      [
        (gemDefaults a)
        (stdenv.lib.maybeAttr name {} patches)
        (stdenv.lib.maybeAttr basename {} patches)
      ]
    ) ["mergeAttrBy"]);
  gemsWithVersions = stdenv.lib.mapAttrs gem gemsGenerated.gems;
  gems = gemsWithVersions // gemsGenerated.aliases;
in
gems
