{ lib, fetchFromGitHub }:

let
  pname = "shabnam-fonts";
  version = "4.0.0";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "shabnam-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/shabnam-fonts {} \;
  '';
  sha256 = "0wfyaaj2pq2knz12l7rsc4wc703cbz0r8gkcya5x69p0aixch8ba";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/shabnam-font;
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی شبنم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
