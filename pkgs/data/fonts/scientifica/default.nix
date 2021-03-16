{ lib, fetchurl }:

let
  version = "2.2";
in fetchurl rec {
  name = "scientifica-${version}";

  url = "https://github.com/NerdyPepper/scientifica/releases/download/v${version}/scientifica.tar";

  downloadToTemp = true;

  recursiveHash = true;

  sha256 = "sha256-mkZnuW+CB20t6MEpEeQR1CWkIUtqgVwrKN4sezQRaB4=";

  postFetch = ''
    tar xf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/fonts/misc
    install scientifica/ttf/*.ttf $out/share/fonts/truetype
    install scientifica/otb/*.otb $out/share/fonts/misc
    install scientifica/bdf/*.bdf $out/share/fonts/misc
  '';

  meta = with lib; {
    description = "Tall and condensed bitmap font for geeks";
    homepage = "https://github.com/NerdyPepper/scientifica";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
