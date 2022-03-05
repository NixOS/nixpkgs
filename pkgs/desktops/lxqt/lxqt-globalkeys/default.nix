{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtbase
, qttools
, qtx11extras
, qtsvg
, kwindowsystem
, liblxqt
, libqtxdg
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-globalkeys";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "ccvDcEstSUVvJ7gf0bsCxCPPMRXSkZh+tKOKWNnzMt4=";
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

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-globalkeys";
    description = "LXQt service for global keyboard shortcuts registration";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
