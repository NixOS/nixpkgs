{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, qtbase
, qttools
, qtsvg
, qtx11extras
, kwindowsystem
, liblxqt
, libqtxdg
, qtxdg-tools
, procps
, xorg
, xdg-user-dirs
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-session";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-kVDPJPYBwK7aXCIWGClwfM9J3067U8lPVWt0jFfqooY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtx11extras
    kwindowsystem
    liblxqt
    libqtxdg
    qtxdg-tools
    procps
    xorg.libpthreadstubs
    xorg.libXdmcp
    xdg-user-dirs
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-session";
    description = "An alternative session manager ported from the original razor-session";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
