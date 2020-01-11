{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, liblxqt, libqtxdg }:

mkDerivation rec {
  pname = "lxqt-globalkeys";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1ij9abjnqbnkcb7qqk3x7y4amr6l7kkmwhdpc0x2qk4yikn5ijdg";
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
    liblxqt
    libqtxdg
  ];

  meta = with lib; {
    description = "LXQt service for global keyboard shortcuts registration";
    homepage = https://github.com/lxqt/lxqt-globalkeys;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
