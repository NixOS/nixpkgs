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
, solid
, kidletime
, liblxqt
, libqtxdg
, lxqt-globalkeys
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-powermanagement";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-1koP+ElW5e85TJqToaErnGkTn3uRHk45bDDrXG6Oy68=";
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
    solid
    kidletime
    liblxqt
    libqtxdg
    lxqt-globalkeys
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-powermanagement";
    description = "Power management module for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
