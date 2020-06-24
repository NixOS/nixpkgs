{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "shabnam-fonts";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "shabnam-font";
    rev = "v${version}";
    sha256 = "1y4w16if2y12028b9vyc5l5c5bvcglhxacv380ixb8fcc4hfakmb";
  };

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/shabnam-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی شبنم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
