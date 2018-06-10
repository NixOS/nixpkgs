{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "libqtxdg-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libqtxdg";
    rev = version;
    sha256 = "03kdrx5sgrl93yband87n30i0k2mv6dknwdw2adz45j5z9rhd3z6";
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
    homepage = https://github.com/lxde/libqtxdg;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
