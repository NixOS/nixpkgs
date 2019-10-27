{ lib, fetchzip }:

let
  version = "3.0.3";
in fetchzip rec {
  name = "overpass-${version}";

  url = "https://github.com/RedHatBrand/Overpass/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype ; unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}    ; unzip -j $downloadedFile \*.md  -d $out/share/doc/${name}
  '';

  sha256 = "1m6p7rrlyqikjvypp4698sn0lp3a4z0z5al4swblfhg8qaxzv5pg";

  meta = with lib; {
    homepage = http://overpassfont.org/;
    description = "Font heavily inspired by Highway Gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
