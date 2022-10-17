{ lib, fetchzip }:
let
  version = "2.3.1";
in
fetchzip {
  name = "3270font-${version}";

  url = "https://github.com/rbanffy/3270font/releases/download/v${version}/3270_fonts_3b8f2fb.zip";

  sha256 = "06n87ydn2ayfhpg8318chmnwmdk3d4mmy65fcgf8frbiv2kpqncs";

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
