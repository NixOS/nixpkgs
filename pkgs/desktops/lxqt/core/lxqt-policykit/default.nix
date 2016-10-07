{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-policykit";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0rbqzh8r259cc44f1cb236p9c3lp195zjdsw3w1nz7j7gzv9yjnd";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    qt5.polkit-qt
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The LXQt PolicyKit agent";
    homepage = https://github.com/lxde/lxqt-policykit;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
