{ lib, fetchFromGitHub }:

let
  pname = "sahel-fonts";
  version = "1.0.0-alpha22";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "sahel-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/sahel-fonts {} \;
  '';
  sha256 = "0vj8ydv50rjanb0favd7rh4r9rv5fl39vqwvzkpgfdcdawn0xjm7";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/sahel-font;
    description = "A Persian (farsi) Font - فونت (قلم) فارسی ساحل";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
