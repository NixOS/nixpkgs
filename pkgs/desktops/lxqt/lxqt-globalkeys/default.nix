{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, liblxqt, libqtxdg }:

mkDerivation rec {
  pname = "lxqt-globalkeys";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0q7hfbs4dhsgyzch2msq2hsfzzfgbc611ki9x1x132n7zqk76pmp";
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
    description = "Daemon used to register global keyboard shortcuts";
    homepage = https://github.com/lxqt/lxqt-globalkeys;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
