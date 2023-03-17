{ lib, fetchurl, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "carlito";
  version = "20130920";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/crosextrafonts-carlito-${version}.tar.gz";
    sha256 = "sha256-S9ErbLwyHBzxbaduLFhcklzpVqCAZ65vbGTv9sz9r1o=";
  };

  installPhase = ''
    mkdir -p $out/etc/fonts/conf.d
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
    cp -v ${./calibri-alias.conf} $out/etc/fonts/conf.d/30-calibri.conf
  '';

  meta = with lib; {
    # This font doesn't appear to have any official web site but this
    # one provides some good information and samples.
    homepage = "http://openfontlibrary.org/en/font/carlito";
    description = "A sans-serif font metric-compatible with Microsoft Calibri";
    longDescription = ''
      Carlito is a free font that is metric-compatible with the
      Microsoft Calibri font. The font is designed by Łukasz Dziedzic
      of the tyPoland foundry and based upon his Lato font.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];

    # Reduce the priority of this package. The intent is that if you
    # also install the `vista-fonts` package, then you probably will
    # not want to install the font alias of this package.
    priority = 10;
  };
}
