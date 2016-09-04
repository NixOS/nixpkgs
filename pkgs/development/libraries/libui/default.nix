{ stdenv, fetchgit, cmake, pkgconfig, gtk3 }:

let
  shortName = "libui";
  version   = "3.1a";
in
  stdenv.mkDerivation rec {
    name = "${shortName}-${version}";
    src  = fetchgit {
      url    = "https://github.com/andlabs/libui.git";
      rev    = "6ebdc96b93273c3cedf81159e7843025caa83058";
      sha256 = "1lpbfa298c61aarlzgp7vghrmxg1274pzxh1j9isv8x758gk6mfn";
    };

    buildInputs = [ cmake pkgconfig gtk3 ];

    installPhase = ''
      mkdir -p $out/{include,lib}
      mkdir -p $out/lib/pkgconfig

      mv ./out/${shortName}.so.0 $out/lib/
      ln -s $out/lib/${shortName}.so.0 $out/lib/${shortName}.so

      cp $src/ui.h $out/include
      cp $src/ui_unix.h $out/include

      cp ${./libui.pc} $out/lib/pkgconfig/${shortName}.pc
      substituteInPlace $out/lib/pkgconfig/${shortName}.pc \
        --subst-var-by out $out \
        --subst-var-by version "${version}"
    '';

    meta = {
      homepage    = https://github.com/andlabs/libui;
      description = "Simple and portable (but not inflexible) GUI library in C that uses the native GUI technologies of each platform it supports.";
      platforms   = stdenv.lib.platforms.linux;
    };
  }
