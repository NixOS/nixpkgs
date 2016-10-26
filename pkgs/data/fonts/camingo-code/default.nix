{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "camingo-code-${version}";
  version = "1.0";

  src = fetchurl {
    url = https://github.com/chrissimpkins/codeface/releases/download/font-collection/codeface-fonts.zip;
    sha256 = "1gbpfa5mqyhi5yrb6dl708pggiwp002b532fn3axiagb0cxxf02s";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v camingo-code/*.ttf $out/share/fonts/truetype/
    cp -v camingo-code/*.txt $out/share/doc/${name}/
  '';

  meta = with stdenv.lib; {
    homepage = https://www.myfonts.com/fonts/jan-fromm/camingo-code/;
    description = "A monospaced typeface designed for source-code editors";
    platforms = platforms.all;
    license = licenses.cc-by-nd-30;
  };
}
