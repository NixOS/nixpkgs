{ lib, fetchFromGitHub }:

let
  pname = "parastoo-fonts";
  version = "1.0.0-alpha5";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "parastoo-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/parastoo-fonts {} \;
  '';
  sha256 = "10jbii6rskcy4akjl5yfcqv4mfwk3nqnx36l6sbxks43va9l04f4";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/parastoo-font;
    description = "A Persian (Farsi) Font - فونت ( قلم ) فارسی پرستو";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
