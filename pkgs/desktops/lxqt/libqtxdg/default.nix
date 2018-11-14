{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "libqtxdg-${version}";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libqtxdg";
    rev = version;
    sha256 = "0lkmwnqk314mlr811rdb96p6i7zg67slxdvd4cdkiwakgbzzaa4m";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase qt5.qtsvg ];

  preConfigure = ''
    cmakeFlagsArray+=(
    "-DQTXDGX_ICONENGINEPLUGIN_INSTALL_PATH=$out/$qtPluginPrefix"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    )
  '';

  meta = with stdenv.lib; {
    description = "Qt implementation of freedesktop.org xdg specs";
    homepage = https://github.com/lxqt/libqtxdg;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
