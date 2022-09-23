{ lib, fetchFromGitHub }:

let
  pname = "vazir-code-font";
  version = "1.1.2";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "vazir-code-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;
  '';
  sha256 = "0ivwpn9xm2zwhwgg9mghyiy5v66cn4786w9j6rkff5cmzshv279r";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/vazir-code-font";
    description = "A Persian (farsi) Monospaced Font for coding";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.dearrude ];
  };
}
