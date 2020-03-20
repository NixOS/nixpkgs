{ lib, fetchzip }:
let
  version = "4.105";
in fetchzip rec {
  name = "vollkorn-${version}";

  url = "http://vollkorn-typeface.com/download/vollkorn-4-105.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf   -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.otf   -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.woff  -d $out/share/fonts/woff
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2
    unzip -j $downloadedFile \*.eot   -d $out/share/fonts/EOT
    unzip -j $downloadedFile {Fontlog,OFL,OFL-FAQ}.txt  -d "$out/share/doc/${name}"
  '';

  sha256 = "0inm64q7bsg0z9hx5ba1qqcchrg7b3qaqkd4h63392515dnpjks9";

  meta = with lib; {
    homepage = "http://vollkorn-typeface.com/";
    description = "The free and healthy typeface for bread and butter use";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ rasendubi ];
  };
}
