{ lib, fetchFromGitHub }:

let
  pname = "nahid-fonts";
  version = "0.3.0";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "rastikerdar";
  repo = "nahid-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/nahid-fonts {} \;
  '';
  sha256 = "0df169sibq14j2mj727sq86c00jm1nz8565v85hkvh4zgz2plb7c";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/nahid-font";
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی ناهید";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
