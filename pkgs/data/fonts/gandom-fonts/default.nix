{ lib, fetchFromGitHub }:

let
  pname = "gandom-fonts";
  version = "0.8";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "rastikerdar";
  repo = "gandom-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/gandom-fonts {} \;
  '';
  sha256 = "sha256-EDS3wwKwe2BIcOCxu7DxkVLCoEoTPP31k5ID51lqn3M=";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/gandom-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی گندم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
