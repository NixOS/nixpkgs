{ lib, stdenv, fetchurl, fontforge }:

stdenv.mkDerivation {
  name = "linux-libertine-5.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/linuxlibertine/5.3.0/LinLibertineSRC_5.3.0_2012_07_02.tgz";
    sha256 = "0x7cz6hvhpil1rh03rax9zsfzm54bh7r4bbrq8rz673gl9h47v0v";
  };

  sourceRoot = ".";

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
    install -m444 -Dt $out/share/fonts/opentype/public *.otf
    install -m444 -Dt $out/share/fonts/truetype/public *.ttf
    install -m444 -Dt $out/share/fonts/type1/public    *.pfb
    install -m444 -Dt $out/share/texmf/fonts/enc       *.enc
    install -m444 -Dt $out/share/texmf/fonts/map       *.map
  '';

  meta = with lib; {
    description = "Linux Libertine Fonts";
    homepage = "http://linuxlibertine.sf.net";
    maintainers = [ ];
    license = licenses.ofl;
  };
}
