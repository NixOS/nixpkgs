{ stdenv, fetchgit, bash, nodejs, haxe, neko, hxcpp, libX11, libXinerama, libXrandr, libXext, libXi, alsaLib, mesa_noglu,
  simulateHaxelibDev, installLibHaxe, buildHaxeLib, withCommas,
  actuate, box2d, layout, munit, mcover, mconsole, mlib, hamcrest, format, webify }:

rec {
  lime = let
    libname = "lime";
    version = "5.0.2";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchgit {
      url = https://github.com/openfl/lime.git;
      rev = "refs/tags/${version}";
      fetchSubmodules = true;
      sha256 = "1jwz6phj7mgm8n3bhjiq98zrjsmxbyr64qzcmhlqddxnsxxzrr2l";
    };
    propagatedBuildInputs = [ munit mcover mconsole mlib hamcrest format ];
    buildInputs = [ haxe neko hxcpp libX11 libXinerama libXrandr libXext libXi alsaLib mesa_noglu ];
    postPatch = ''
      # those pre-compiled binaries do not work on NixOS anyway, and patchelf does not cure them
      rm templates/bin/{node/node,webify}-{linux32,linux64,mac,windows.exe}
      substituteInPlace lime/tools/helpers/NodeJSHelper.hx --replace 'var node = PathHelper.findTemplate (templatePaths, "bin/node/node" + suffix);' 'var node = "${nodejs}/bin/node";'
      substituteInPlace lime/tools/helpers/HTML5Helper.hx  --replace 'var node = PathHelper.findTemplate (templatePaths, "bin/node/node" + suffix);' 'var node = "${nodejs}/bin/node";'
      substituteInPlace lime/tools/helpers/HTML5Helper.hx  --replace 'var webify = PathHelper.findTemplate (templatePaths, "bin/webify" + suffix);'  'var webify = "${webify}/bin/webify";'

      # dynamicaly load libraries
      substituteInPlace project/lib/sdl/include/configs/linux/SDL_config.h      \
        --replace '"libX11.so.6"'       '"${libX11     }/lib/libX11.so.6"'      \
        --replace '"libXext.so.6"'      '"${libXext    }/lib/libXext.so.6"'     \
        --replace '"libXinerama.so.1"'  '"${libXinerama}/lib/libXinerama.so.1"' \
        --replace '"libXi.so.6"'        '"${libXi      }/lib/libXi.so.6"'       \
        --replace '"libxrandr.so.2"'    '"${libXrandr  }/lib/libXrandr.so.6"'
      substituteInPlace project/lib/openal/Alc/backends/alsa.c                  \
        --replace '"libasound.so.2"'    '"${alsaLib    }/lib/libasound.so.2"'
    '';
    buildPhase = ''
      ${simulateHaxelibDev "lime"}

      haxelib run lime

      rm -rf project
      find . -regex '.+\(\.gitignore\|\.gitmodules\)' -delete
    '';
    installPhase = ''
      ${installLibHaxe { inherit libname version; }}

      mkdir -p $out/bin
      cat > $out/bin/lime <<EOF
      #!${bash}/bin/bash

      export HAXELIB_PATH="\$HAXELIB_PATH\''${HAXELIB_PATH:+:}$HAXELIB_PATH:$out/lib/haxe"
      export PATH="\$PATH:${haxe}/bin:${neko}/bin"
      exec haxelib run lime "\$@"
      EOF
      chmod +x $out/bin/lime
    '';
    meta = with stdenv.lib; {
      description = "A foundational Haxe framework for cross-platform development";
      homepage = http://openfl.org;
      license = licenses.mit;
      platforms = platforms.linux; # might work on mac and windows too
    };
  };

  lime-samples = buildHaxeLib rec {
    libname = "lime-samples";
    version = "4.0.1";
    sha256 = "03nqbvnzwmdqqzfwx8nnfxfw63w1b9fi3abn0llqs5ycylxn7rlg";
    meta = lime.meta // { description = "Lime samples"; };
    propagatedBuildInputs = [ hxcpp lime ];
    postFixup = ''
      export HOME=$(mktemp -d)          # for "lime" to create working dir
      for demo in BunnyMark HerokuShaders GameOfLife HelloWorld; do
        ( cd "$out/lib/haxe/${withCommas libname}/${withCommas version}/demos/$demo"
          lime build html5
          lime build linux
          rm -rf Export/linux*/cpp/release/obj )
      done
    '';
  };

  openfl = buildHaxeLib {
    libname = "openfl";
    version = "5.1.2";
    sha256 = "0qpsxbxv0hy99jlmyv3qia1xayjbk6vzxz0jshz9cbwr5yn93n99";
    meta = lime.meta // { description = ''The "Open Flash Library" for fast 2D development''; };
    propagatedBuildInputs = [ lime actuate box2d layout ];
    postFixup = ''
      mkdir -p $out/bin
      cat > $out/bin/openfl <<EOF
      #!${bash}/bin/bash

      export HAXELIB_PATH="\$HAXELIB_PATH\''${HAXELIB_PATH:+:}$HAXELIB_PATH:$out/lib/haxe"
      export PATH="\$PATH:${haxe}/bin:${neko}/bin"
      exec haxelib run openfl "\$@"
      EOF
      chmod +x $out/bin/openfl
    '';
  };

  openfl-samples = buildHaxeLib rec {
    libname = "openfl-samples";
    version = "4.9.0";
    sha256 = "0lgjmnc0r7467w7bcxygbx2ka834sc8l238nsdazsvqilqnh3bx8";
    meta = lime.meta // { description = "OpenFL samples"; };
    propagatedBuildInputs = [ hxcpp openfl ];
    postFixup = ''
      export HOME=$(mktemp -d)          # for "openfl" to create working dir
      for demo in BunnyMark HerokuShaders NyanCat PiratePig TextAlignment TextMetrics; do
        ( cd "$out/lib/haxe/${withCommas libname}/${withCommas version}/demos/$demo"
          openfl build html5
          openfl build linux
          rm -rf Export/linux*/cpp/release/obj )
      done
    '';
  };
}