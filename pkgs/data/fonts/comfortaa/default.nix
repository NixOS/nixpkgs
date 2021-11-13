{ lib, fetchFromGitHub }:

let
  version = "2021-07-29";
in fetchFromGitHub rec {
  name = "comfortaa-${version}";

  owner = "googlefonts";
  repo = "comfortaa";
  rev = "2a87ac6f6ea3495150bfa00d0c0fb53dd0a2f11b";

  postFetch = ''
    tar -xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype $out/share/doc/comfortaa
    cp fonts/TTF/*.ttf $out/share/fonts/truetype
    cp FONTLOG.txt README.md $out/share/doc/comfortaa
  '';

  sha256 = "12ad7qy11q49iv9h3l2d7x7y7kf0hxbqhclb92bzwig8dzly9n2k";

  meta = with lib; {
    homepage = "http://aajohan.deviantart.com/art/Comfortaa-font-105395949";
    description = "A clean and modern font suitable for headings and logos";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
