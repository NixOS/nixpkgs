{ lib, fetchurl }:

let
  version = "2.1";
in fetchurl rec {
  name = "scientifica-${version}";

  url = "https://github.com/NerdyPepper/scientifica/releases/download/v${version}/scientifica-v${version}.tar";

  downloadToTemp = true;

  recursiveHash = true;

  sha256 = "081faa48d6g86pacmgjqa96in72rjldavnwxq6bdq2br33h3qwrz";

  postFetch = ''
    tar xvf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/fonts/misc
    cp scientifica/ttf/*.ttf $out/share/fonts/truetype
    cp scientifica/otb/*.otb $out/share/fonts/misc
    cp scientifica/bdf/*.bdf $out/share/fonts/misc
  '';

  meta = with lib; {
    description = "Tall and condensed bitmap font for geeks";
    homepage = "https://github.com/NerdyPepper/scientifica";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
