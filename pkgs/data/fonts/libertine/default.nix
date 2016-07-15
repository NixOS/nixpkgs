{ stdenv, fetchurl, fontforge }:

stdenv.mkDerivation rec {
  name = "linux-libertine-5.3.0";

  src = fetchurl {
    url = mirror://sourceforge/linuxlibertine/5.3.0/LinLibertineSRC_5.3.0_2012_07_02.tgz;
    sha256 = "0x7cz6hvhpil1rh03rax9zsfzm54bh7r4bbrq8rz673gl9h47v0v";
  };

  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [ fontforge ];

  buildPhase = ''
    for i in *.sfd; do
      fontforge -lang=ff -c \
        'Open($1);
        ScaleToEm(1000);
        Reencode("unicode");
        Generate($1:r + ".ttf");
        Generate($1:r + ".otf");
        Reencode("TeX-Base-Encoding");
        Generate($1:r + ".afm");
        Generate($1:r + ".pfm");
        Generate($1:r + ".pfb");
        Generate($1:r + ".map");
        Generate($1:r + ".enc");
        ' $i;
    done
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/{opentype,truetype,type1}/public
    mkdir -p $out/share/texmf/fonts/{enc,map}
    cp *.otf $out/share/fonts/opentype/public
    cp *.ttf $out/share/fonts/truetype/public
    cp *.pfb $out/share/fonts/type1/public
    cp *.enc $out/share/texmf/fonts/enc
    cp *.map $out/share/texmf/fonts/map
  '';

  meta = {
    description = "Linux Libertine Fonts";
    homepage = http://linuxlibertine.sf.net;
    platforms = stdenv.lib.platforms.all;
  };
}
