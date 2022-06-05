{ lib, fetchFromGitHub }:

let
  pname = "shabnam-fonts";
  version = "5.0.1";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "shabnam-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/shabnam-fonts {} \;
  '';
  sha256 = "sha256-m4G4UtW/0S9CsvaSF7QfthfIxGQ02E7SucdDm5s3G7A=";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/shabnam-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی شبنم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
