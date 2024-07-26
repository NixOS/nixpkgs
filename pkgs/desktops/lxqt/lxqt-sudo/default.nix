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
, sudo
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-sudo";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-J7jiap3qZD+P0kGzt+b3wa16pxbS2fr3OmalhV5O9ro=";
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
    sudo
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-sudo";
    description = "GUI frontend for sudo/su";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
