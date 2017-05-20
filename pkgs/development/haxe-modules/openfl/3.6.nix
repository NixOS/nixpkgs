{ stdenv, fetchgit, bash, nodejs, haxe, neko, hxcpp, libX11, libXinerama, libXrandr, libXext, libXi, alsaLib, mesa_noglu,
  simulateHaxelibDev, installLibHaxe, buildHaxeLib, withCommas,
  lime, openfl, actuate, box2d, layout, munit, mcover, mconsole, mlib, hamcrest, format, webify,
  haxe_3_2, glibc, boehmgc, pcre, zlib }:

rec {
  lime_2_9 = let
    libname = "lime";
    version = "2.9.1";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchgit {
      url = https://github.com/openfl/lime.git;
      rev = "refs/tags/${version}";
      fetchSubmodules = true;
      sha256 = "01yyjn9s3fldxswvprhw7d2bg7p8c6bnq294ci9sg9bc5kiwya4q";
    };
    propagatedBuildInputs = [ munit mcover mconsole mlib hamcrest format ];
    buildInputs = [ haxe_3_2 neko hxcpp libX11 libXinerama libXrandr libXext libXi alsaLib mesa_noglu ];
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

      haxelib run lime rebuild linux ${if stdenv.is64bit then "-64" else ""} -Dlegacy

      # replace pre-compiled neko-2.0.0 binaries
      rm {,legacy/}templates/neko/{bin/neko-linux{,64},ndll/linux{,64}/*}
      ln -s ${neko}/bin/neko        templates/neko/bin/neko-linux${if stdenv.is64bit then "64" else ""}
      ln -s ${neko}/bin/neko legacy/templates/neko/bin/neko-linux${if stdenv.is64bit then "64" else ""}

      rm -rf project
      find . -regex '.+\(\.gitignore\|\.gitmodules\)' -delete
    '';
    installPhase = ''
      ${installLibHaxe { inherit libname version; }}

      mkdir -p $out/bin
      cat > $out/bin/lime <<EOF
      #!${bash}/bin/bash

      export HAXELIB_PATH="\$HAXELIB_PATH\''${HAXELIB_PATH:+:}$HAXELIB_PATH:$out/lib/haxe"
      echo "HAXELIB_PATH=\$HAXELIB_PATH"
      export PATH="\$PATH:${haxe}/bin:${neko}/bin"
      exec haxelib run lime "\$@"
      EOF
      chmod +x $out/bin/lime
    '';
    inherit (lime) meta;
  };

  openfl_3_6 = buildHaxeLib {
    libname = "openfl";
    version = "3.6.1";
    sha256 = "1f3v6m4fdsq77a74633qq4lfc1nm3i7dqc5zj70gg1306a0wrwxy";
    propagatedBuildInputs = [ lime_2_9 ];
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
    inherit (openfl) meta;
  };
}