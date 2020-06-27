{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "sahel-fonts";
  version = "1.0.0-alpha22";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "sahel-font";
    rev = "v${version}";
    sha256 = "1kx7byzb5zxspq0i4cvgf4q7sm6xnhdnfyw9zrb1wfmdv3jzaz7p";
  };

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/sahel-font";
    description = "A Persian (farsi) Font - فونت (قلم) فارسی ساحل";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ linarcx ];
  };
}
