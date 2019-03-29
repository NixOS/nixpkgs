{ stdenv, fetchFromGitHub, cmake, pkgconfig, pcre, qtbase, glib }:

stdenv.mkDerivation rec {
  pname = "lxqt-build-tools";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0i7m9s4g5rsw28vclc9nh0zcapx85cqfwxkx7rrw7wa12svy7pm2";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qtbase glib pcre ];

  preConfigure = ''cmakeFlags+=" -DLXQT_ETC_XDG_DIR=$out/etc/xdg"'';

  meta = with stdenv.lib; {
    description = "Various packaging tools and scripts for LXQt applications";
    homepage = https://github.com/lxqt/lxqt-build-tools;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
