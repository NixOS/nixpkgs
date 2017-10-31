{stdenv, fetchzip}:

let
  version = "20130920";
in fetchzip rec {
  name = "carlito-${version}";

  url = "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/crosextrafonts-carlito-${version}.tar.gz";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    mkdir -p $out/etc/fonts/conf.d
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
    cp -v ${./calibri-alias.conf} $out/etc/fonts/conf.d/30-calibri.conf
  '';

  sha256 = "0d72zy6kdmxgpi63r3yvi3jh1hb7lvlgv8hgd4ag0x10dz18mbzv";

  meta = with stdenv.lib; {
    # This font doesn't appear to have any official web site but this
    # one provides some good information and samples.
    homepage = http://openfontlibrary.org/en/font/carlito;
    description = "A sans-serif font metric-compatible with Microsoft Calibri";
    longDescription = ''
      Carlito is a free font that is metric-compatible with the
      Microsoft Calibri font. The font is designed by Łukasz Dziedzic
      of the tyPoland foundry and based his Lato font.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];

    # Reduce the priority of this package. The intent is that if you
    # also install the `vista-fonts` package, then you probably will
    # not want to install the font alias of this package.
    priority = 10;
  };
}
