{ stdenv, haxe, neko, hxcpp, format, buildHaxeLib, fetchFromGitHub, simulateHaxelibDev, withCommas, installLibHaxe, libX11, libXext, libXinerama, libXi, libXrandr, mesa_noglu }:

let
  meta = with stdenv.lib; {
    description = "NME provides a backend for native iOS, Android, Windows, Mac and Linux applications, using a Flash inspired API";
    homepage = http://nmehost.com;
    license = licenses.mit;
    platforms = platforms.linux; # might work on mac and windows too
  };

  nme-toolkit = buildHaxeLib rec {
    libname = "nme-toolkit";
    version = "6.1.0";
    sha256 = "1jqxvn1i1q3r13lyyzsb2k4l9i4n9zkap0j6lvmfql4wq753yy76";
    propagatedBuildInputs = [ libX11 libXext libXinerama libXi libXrandr mesa_noglu ];
    postFixup = ''
      # dynamicaly load libraries
      substituteInPlace $out/lib/haxe/${withCommas libname}/${withCommas version}/sdl/include/configs/linux/SDL_config.h \
        --replace '"libX11.so.6"'       '"${libX11     }/lib/libX11.so.6"'      \
        --replace '"libXext.so.6"'      '"${libXext    }/lib/libXext.so.6"'     \
        --replace '"libXinerama.so.1"'  '"${libXinerama}/lib/libXinerama.so.1"' \
        --replace '"libXi.so.6"'        '"${libXi      }/lib/libXi.so.6"'       \
        --replace '"libxrandr.so.2"'    '"${libXrandr  }/lib/libXrandr.so.6"'
    '';
    inherit meta;
  };
in rec {
  gm2d = buildHaxeLib {
    libname = "gm2d";
    version = "3.3.24";
    sha256 = "0lvy2y3n6dxj527sipwb2hs1fc7mqv6bkkm0r49603l0fw6rc6d9";
    meta = meta // { description = "GM2D helper classes for rapid game making in 2D"; };
  };

  nme = let
    libname = "nme";
    version = "6.0.45";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxenme";
      repo = "nme";
      rev = "652f0a9"; # there are no tags on github, version -> git_revision table is at http://nmehost.com/nme/
      sha256 = "0pvanf1gfd8dhd3z7gcbppnrl6dk6j1jvxh2sc38kcss5sjs26q9";
    };
    buildInputs = [ haxe neko hxcpp format gm2d ];
    propagatedBuildInputs = [ nme-toolkit ];
    buildPhase = ''
      ${simulateHaxelibDev "nme"}
      ( cd tools/nme
        haxe compile.hxml )
      ( cd project
        neko build.n ndll-linux${ if stdenv.is64bit then "-m64" else "-m32" }
        rm -rf obj )
    '';
    doCheck = false; # too slow
    checkPhase = ''
      for demo in samples/*; do
       ( cd $demo
         haxelib run nme build )
      done
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };
}