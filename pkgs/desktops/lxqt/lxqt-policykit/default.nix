{ lib
, stdenv
, fetchFromGitHub
, cmake
, kwindowsystem
, liblxqt
, libqtxdg
, lxqt-build-tools
, pcre
, pkg-config
, polkit
, polkit-qt-1
, qtbase
, qtsvg
, qttools
, qtwayland
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "lxqt-policykit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-oYKvQBilpD2RLhN1K6qgRNNAfohCOqmBrKcWy1fXZT8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    pcre
    polkit
    polkit-qt-1
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-policykit";
    description = "The LXQt PolicyKit agent";
    mainProgram = "lxqt-policykit-agent";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
