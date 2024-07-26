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
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-globalkeys";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-2S61d7BSuDPU1dNXLENpmpt6BB+CAeCtBVQS+ZGxrtU=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-globalkeys";
    description = "LXQt service for global keyboard shortcuts registration";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
