{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "caladea";
  version = "20130214";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/crosextrafonts-${version}.tar.gz";
    hash = "sha256-xI0cL9YTycBslZw02nuDiAWeJAjSuxmEXcPtNfduTQk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/fonts/conf.d
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
    cp -v ${./cambria-alias.conf} $out/etc/fonts/conf.d/30-cambria.conf

    runHook postInstall
  '';

  meta = with lib; {
    # This font doesn't appear to have any official web site but this
    # one provides some good information and samples.
    homepage = "http://openfontlibrary.org/en/font/caladea";
    description = "Serif font metric-compatible with Microsoft Cambria";
    longDescription = ''
      Caladea is a free font that is metric-compatible with the
      Microsoft Cambria font. Developed by Carolina Giovagnoli and
      Andrés Torresi at Huerta Tipográfica foundry.
    '';
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];

    # Reduce the priority of this package. The intent is that if you
    # also install the `vista-fonts` package, then you probably will
    # not want to install the font alias of this package.
    priority = 10;
  };
}
