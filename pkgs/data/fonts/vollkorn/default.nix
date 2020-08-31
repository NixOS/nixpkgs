{ lib, fetchzip }:

let
  version = "4.105";
in fetchzip {
  name = "vollkorn-${version}";

  url = "http://vollkorn-typeface.com/download/vollkorn-${lib.replaceStrings [ "." ] [ "-" ] version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "0x1rgi0q13yq0j22mw39zf9l1fsvz90qr83nhy1blg6w045jh1h6";

  meta = with lib; {
    homepage = "http://vollkorn-typeface.com/";
    description = "The free and healthy typeface for bread and butter use";
    license = licenses.ofl;
    maintainers = [ maintainers.tfmoraes ];
    platforms = platforms.all;
  };
}
