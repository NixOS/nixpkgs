{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "lmmath-0.903";
  
  src = fetchurl {
    url = "http://www.gust.org.pl/projects/e-foundry/lm-math/download/lmmath0903otf";
    sha256 = "ee96cb14f5c746d6c6b9ecfbdf97dafc2f535be3dd277e15e8ea6fb594995d64";
    name = "lmmath-0.903.zip";
  };

  buildInputs = [unzip];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/texmf-dist/fonts/opentype
    mkdir -p $out/share/fonts/opentype

    cp *.{OTF,otf} $out/texmf-dist/fonts/opentype/lmmath-regular.otf
    cp *.{OTF,otf} $out/share/fonts/opentype/lmmath-regular.otf

    ln -s $out/texmf* $out/share/
  '';

  meta = {
    description = "Latin Modern font";
    platforms = stdenv.lib.platforms.unix;
  };
}

