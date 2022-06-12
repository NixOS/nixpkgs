{ lib, fetchFromGitHub }:

let
  pname = "parastoo-fonts";
  version = "2.0.1";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "parastoo-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/parastoo-fonts {} \;
  '';
  sha256 = "sha256-4smobLS43DB7ISmbWDWX0IrtaeiyXpi1QpAiL8NyXoQ=";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/parastoo-font";
    description = "A Persian (Farsi) Font - فونت ( قلم ) فارسی پرستو";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
