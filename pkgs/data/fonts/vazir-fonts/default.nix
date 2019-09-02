{ lib, fetchFromGitHub }:

let
  pname = "vazir-fonts";
  version = "19.2.0";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "vazir-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/vazir-fonts {} \;
  '';
  sha256 = "008h095rjrcjhz9h02v6cf3gv64khj21lii4zffgpdlmvfs29f8l";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/vazir-font;
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
