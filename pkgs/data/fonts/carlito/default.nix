{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "carlito-unstable";
  version = "20230309";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "carlito";
    rev = "3a810cab78ebd6e2e4eed42af9e8453c4f9b850a";
    hash = "sha256-U4TvZZ7n7dr1/14oZkF1Eo96ZcdWIDWron70um77w+E=";
  };

  installPhase = ''
    mkdir -p $out/etc/fonts/conf.d
    mkdir -p $out/share/fonts/truetype
    cp -v fonts/ttf/*.ttf $out/share/fonts/truetype
    cp -v ${./calibri-alias.conf} $out/etc/fonts/conf.d/30-calibri.conf
  '';

  meta = with lib; {
    # This font doesn't appear to have any official web site but this
    # one provides some good information and samples.
    homepage = "https://github.com/googlefonts/carlito";
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
