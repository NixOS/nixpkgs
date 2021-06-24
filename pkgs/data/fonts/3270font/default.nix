{ lib, fetchzip }:
let
  version = "2.3.0";
in
fetchzip {
  name = "3270font-${version}";

  url = "https://github.com/rbanffy/3270font/releases/download/v${version}/3270_fonts_fd00815.zip";

  sha256 = "0ny2jcsfa1kfzkm979dfzqv756ijm5xirm02ln7a4kwhxxsm5xr1";

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
