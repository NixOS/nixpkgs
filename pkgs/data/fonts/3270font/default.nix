{ lib, fetchzip }:
let
  version = "2.2.1";
in
fetchzip {
  name = "3270font-${version}";

  url = "https://github.com/rbanffy/3270font/releases/download/v${version}/3270_fonts_70de9c7.zip";

  sha256 = "0spz9abp87r3bncjim6hs47fmhg86qbgips4x6nfpqzg5qh2xd2m";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.afm -d $out/share/fonts/type1
  '';

  meta = with lib; {
    description = "Monospaced font based on IBM 3270 terminals";
    homepage = "https://github.com/rbanffy/3270font";
    changelog = "https://github.com/rbanffy/3270font/blob/v${version}/CHANGELOG.md";
    license = [ licenses.bsd3 licenses.ofl ];
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
