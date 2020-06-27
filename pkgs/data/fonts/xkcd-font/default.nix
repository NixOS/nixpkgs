{ lib, mkFont, fetchFromGitHub }:

mkFont {
  pname = "xkcd-font";
  version = "unstable-2017-08-24";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "xkcd-font";
    rev = "5632fde618845dba5c22f14adc7b52bf6c52d46d";
    sha256 = "01wpfc1yp93b37r472mx2b459il5gywnv5sl7pp9afpycb3i4f6l";
  };

  meta = with lib; {
    description = "The xkcd font";
    homepage = "https://github.com/ipython/xkcd-font";
    license = licenses.cc-by-nc-30;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
