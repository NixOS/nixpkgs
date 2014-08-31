# build-time overrides for some gems
#
# gems in here generally involve native extensions; there's no way to tell
# based on the gemfile

{ fetchurl, writeScript, ruby, ncurses, sqlite, libxml2, libxslt, libffi
, zlib, libuuid, gems, jdk, python, stdenv, libiconvOrEmpty, imagemagick
, gnumake, pkgconfig, which, postgresql, v8_3_16_14, clang }:

let
  v8 = v8_3_16_14;

  patchUsrBinEnv = writeScript "path-usr-bin-env" ''
    #!/bin/sh
    echo "==================="
    find "$1" -type f -name "*.rb" | xargs sed -i "s@/usr/bin/env@$(type -p env)@g"
    find "$1" -type f -name "*.mk" | xargs sed -i "s@/usr/bin/env@$(type -p env)@g"
  '';

in

{
  barber = { gemFlags = "--ignore-dependencies"; dontBuild = 1; };
  ember_data_source = { gemFlags = "--ignore-dependencies"; };
  ember_rails = { gemFlags = "--ignore-dependencies"; };

  rbtrace = { dontBuild = 1; };
  method_source = { dontBuild = 1; };

  pg = { buildFlags = ["--with-pg-config=${postgresql}/bin/pg_config"]; };

  nokogiri = {
    buildInputs = [ libxml2 ];
    buildFlags =
      [ "--with-xml2-dir=${libxml2} --with-xml2-include=${libxml2}/include/libxml2"
        "--with-xslt-dir=${libxslt}" "--use-system-libraries"
      ];
  };

  therubyracer = {
    preBuild = ''
      addToSearchPath RUBYLIB "${gems.libv8}/${ruby.gemPath}/gems/libv8-3.16.14.3/lib"
      addToSearchPath RUBYLIB "${gems.libv8}/${ruby.gemPath}/gems/libv8-3.16.14.3/ext"
      ln -s ${clang}/bin/clang $TMPDIR/gcc
      ln -s ${clang}/bin/clang++ $TMPDIR/g++
      export PATH=$TMPDIR:$PATH
    '';

    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      cat >> $out/nix-support/setup-hook <<EOF
        export DYLD_INSERT_LIBRARIES="$DYLD_INSERT_LIBRARIES''${!DYLD_INSERT_LIBRARIES:+:}${v8}/lib/libv8.dylib"
      EOF
    '';

    buildFlags = [
      "--with-v8-dir=${v8}" "--with-v8-include=${v8}/include"
      "--with-v8-lib=${v8}/lib"
    ];
  };

  libv8 = {
    dontBuild = true;
    buildFlags = [ "--with-system-v8" ];
  };

  xrefresh_server =
    let
      patch = fetchurl {
        url = "http://mawercer.de/~nix/xrefresh.diff.gz";
        sha256 = "1f7bnmn1pgkmkml0ms15m5lx880hq2sxy7vsddb3sbzm7n1yyicq";
      };
    in {
      propagatedBuildInputs = [ gems.rb_inotify ];

      # monitor implementation for Linux
      postInstall = ''
        cd $out/${ruby.gemPath}/gems/*
        zcat ${patch} | patch -p 1
      ''; # */
    };

  bundler = { dontPatchShebangs=1; };
}
