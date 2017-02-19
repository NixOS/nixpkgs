{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt, sudo }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-sudo";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0imy4cs51im81rd0wa03wy418cdv9gqqgmwkc7v58cip7h665pyk";
  };

  nativeBuildInputs = [
    cmake
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    sudo
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "GUI frontend for sudo/su";
    homepage = https://github.com/lxde/lxqt-sudo;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
