{ lib, fetchzip }:

let
  version = "3.0.5";
in fetchzip rec {
  name = "overpass-${version}";

  url = "https://github.com/RedHatOfficial/Overpass/releases/download/v${version}/overpass-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts $out/share/doc
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.md  -d $out/share/doc/${name}
  '';

  sha256 = "1fpyhd6x3i3g0xxjmyfnjsri1kkvci15fv7jp1bnza7k0hz0bnha";

  meta = with lib; {
    homepage = "https://overpassfont.org/";
    description = "Font heavily inspired by Highway Gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
