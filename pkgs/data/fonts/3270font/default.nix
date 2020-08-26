{ lib, fetchzip }:
let
  version = "2.0.4";
in
fetchzip rec {
  name = "3270font-${version}";

  url = "https://github.com/rbanffy/3270font/releases/download/v${version}/3270_fonts_ece94f6.zip";

  sha256 = "04q7dnrlq5hm30iibh3jafb33m5lwsgb3g9n9i188sg02ydkrsl9";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.woff -d $out/share/fonts/woff
  '';

  meta = with lib; {
    description = "Monospaced font based on IBM 3270 terminals";
    homepage = "https://github.com/rbanffy/3270font";
    license = [ licenses.bsd3 licenses.ofl ];
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
