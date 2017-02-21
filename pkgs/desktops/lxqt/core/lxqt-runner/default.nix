{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt,
menu-cache, muparser }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-runner";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1nsxm0fplwrzz3vccd5fm82lpl4fqss6kv558zj44vzpsl13l954";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    lxqt.lxqt-common
    lxqt.lxqt-globalkeys
    menu-cache
    muparser
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "Tool used to launch programs quickly by typing their names";
    homepage = https://github.com/lxde/lxqt-runner;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
