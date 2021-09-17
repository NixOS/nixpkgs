{ lib, fetchFromGitHub }:

let
  version = "3.101";
in fetchFromGitHub rec {
  name = "comfortaa-${version}";

  owner = "googlefonts";
  repo = "comfortaa";
  rev = version;

  postFetch = ''
    tar -xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype $out/share/doc/comfortaa
    cp fonts/TTF/*.ttf $out/share/fonts/truetype
    cp FONTLOG.txt README.md $out/share/doc/comfortaa
  '';

  sha256 = "06jhdrfzl01ma085bp354g002ypmkbp6a51jn1lsj77zfj2mfmfc";

  meta = with lib; {
    homepage = "http://aajohan.deviantart.com/art/Comfortaa-font-105395949";
    description = "A clean and modern font suitable for headings and logos";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
