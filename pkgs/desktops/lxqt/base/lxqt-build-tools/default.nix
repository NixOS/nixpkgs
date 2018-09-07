{ stdenv, fetchFromGitHub, cmake, pkgconfig, pcre, qt5, glib }:

stdenv.mkDerivation rec {
  name = "lxqt-build-tools-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-build-tools";
    rev = version;
    sha256 = "0dcwzrijmn4sgivmy2zwz3xa4y69pwhranyw0m90g0pp55di2psz";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt5.qtbase glib pcre ];

  preConfigure = ''cmakeFlags+=" -DLXQT_ETC_XDG_DIR=$out/etc/xdg"'';

  meta = with stdenv.lib; {
    description = "Various packaging tools and scripts for LXQt applications";
    homepage = https://github.com/lxqt/lxqt-build-tools;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
