{ lib, fetchFromGitHub }:

let
  pname = "samim-fonts";
  version = "3.1.0";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "samim-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/samim-fonts {} \;
  '';
  sha256 = "0mmhncqg48dp0d7l725dv909zswbkk22dlqzcdfh6k6cgk2gn08q";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/samim-font;
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی صمیم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
