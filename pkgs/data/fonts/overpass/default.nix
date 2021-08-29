{ lib, fetchzip }:

let
  version = "3.0.4";
in fetchzip rec {
  name = "overpass-${version}";

  url = "https://github.com/RedHatBrand/Overpass/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype ; unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}    ; unzip -j $downloadedFile \*.md  -d $out/share/doc/${name}
  '';

  sha256 = "13b4yam0nycclccxidzj2fa3nwms5qji7gfkixdnl4ybf0f56b64";

  meta = with lib; {
    homepage = "https://overpassfont.org/";
    description = "Font heavily inspired by Highway Gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
