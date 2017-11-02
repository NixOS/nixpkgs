{ stdenv, fetchFromGitHub, cmake, pkgconfig, pcre, qt5 }:

stdenv.mkDerivation rec {
  name = "lxqt-build-tools-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxqt-build-tools";
    rev = version;
    sha256 = "0i3pzgyd80n73dnqs8f6axinaji7biflgqsi33baxn4r1hy58ym1";
  };

  nativeBuildInputs = [ cmake pkgconfig pcre qt5.qtbase ];

  preConfigure = ''cmakeFlags+=" -DLXQT_ETC_XDG_DIR=$out/etc/xdg"'';

  meta = with stdenv.lib; {
    description = "Various packaging tools and scripts for LXQt applications";
    homepage = https://github.com/lxde/lxqt-build-tools;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
