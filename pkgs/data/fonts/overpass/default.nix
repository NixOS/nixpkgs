{ stdenv, fetchzip }:

let
  version = "3.0.2";
in fetchzip rec {
  name = "overpass-${version}";

  url = "https://github.com/RedHatBrand/Overpass/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype ; unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}    ; unzip -j $downloadedFile \*.md  -d $out/share/doc/${name}
  '';

  sha256 = "05zv3zcfc9a707sn3hhf46b126k19d9byzvi5ixp5y2548vjvl6s";

  meta = with stdenv.lib; {
    homepage = http://overpassfont.org/;
    description = "Font heavily inspired by Highway Gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
