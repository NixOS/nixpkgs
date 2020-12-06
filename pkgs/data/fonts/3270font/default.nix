{ lib, fetchzip }:
let
  version = "2.1.0";
in
fetchzip {
  name = "3270font-${version}";

  url = "https://github.com/rbanffy/3270font/releases/download/v.${version}/3270_fonts_fba25eb.zip";

  sha256 = "04xqgiznd6d3c1rdbbdmd87rjy9bnhh00lm8xzmal1zidcr2g0n9";

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
