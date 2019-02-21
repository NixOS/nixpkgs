{ stdenv, fetchFromGitHub, cmake, qtbase, qtsvg }:

stdenv.mkDerivation rec {
  pname = "libqtxdg";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0qgqqgy15h0d1fwk4mnbv2hirz8njjjlng64bv33rc6wwrsaa50b";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase qtsvg ];

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
