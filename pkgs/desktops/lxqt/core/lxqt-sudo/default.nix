{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt, sudo }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-sudo";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0nmn0j5qvqpkhlq8yvl8ycn3hijbnwxd32hhmxhcnaq07cmzbg1j";
  };

  nativeBuildInputs = [ cmake ];

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
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
