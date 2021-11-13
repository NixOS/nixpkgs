{ lib, fetchzip }:

let
  version = "4.004";
in fetchzip {
  name = "source-serif-${version}";

  url = "https://github.com/adobe-fonts/source-serif/releases/download/${version}R/source-serif-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,variable}
    unzip -j $downloadedFile "*/OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "*/TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "*/VAR/*.otf" -d $out/share/fonts/variable
  '';

  sha256 = "06814hcp20abca6p0ii61f23g6h1ibqyhq30lsva59wbwx5iha0h";

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-serif/";
    description = "Typeface for setting text in many sizes, weights, and languages. Designed to complement Source Sans";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
