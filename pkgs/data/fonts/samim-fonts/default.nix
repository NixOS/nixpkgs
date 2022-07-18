{ lib, fetchFromGitHub }:

let
  pname = "samim-fonts";
  version = "4.0.4";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "samim-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/samim-fonts {} \;
  '';
  sha256 = "sha256-WYSJ2mAzAe5H0EaMYU3qNVcQ0lRuHsjZ11YmLnZ2FCo=";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/samim-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی صمیم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
