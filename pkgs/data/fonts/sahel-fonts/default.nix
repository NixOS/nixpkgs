{ lib, fetchFromGitHub }:

let
  pname = "sahel-fonts";
  version = "3.4.0";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "sahel-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/sahel-fonts {} \;
  '';
  sha256 = "sha256-MrKSgz9WpVgLS37uH/7S0LPBD/n3GLXeUCMBD7x5CG8=";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/sahel-font";
    description = "A Persian (farsi) Font - فونت (قلم) فارسی ساحل";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
