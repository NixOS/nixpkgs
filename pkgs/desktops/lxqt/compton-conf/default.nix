{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, lxqt,
  libconfig }:

mkDerivation rec {
  pname = "compton-conf";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0bx21r83ahmsqf7bm1h17pi4y9js1iqsv7nwnlq58rc0ddkkhcdb";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    libconfig
  ];

  preConfigure = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg" \
    '';

  meta = with lib; {
    description = "GUI configuration tool for compton X composite manager";
    homepage = https://github.com/lxqt/compton-conf;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
