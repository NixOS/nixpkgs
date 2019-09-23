{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, solid, kidletime, liblxqt, libqtxdg }:

mkDerivation rec {
  pname = "lxqt-powermanagement";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1nhp4a28bpczhwz8b8da355zsxr1qwmkrm3bwllwp39liw947clx";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    solid
    kidletime
    liblxqt
    libqtxdg
  ];

  meta = with lib; {
    description = "Power management module for LXQt";
    homepage = https://github.com/lxqt/lxqt-powermanagement;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
