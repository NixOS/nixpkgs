{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, libconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "compton-conf";
  version = "0.2.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "04svxawa8l0ciflrspkzi13nnl7bljmfwwrgxn5lb3sw6qdcmdlk";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    libconfig
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "GUI configuration tool for compton X composite manager";
    homepage = https://github.com/lxde/compton-conf;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
