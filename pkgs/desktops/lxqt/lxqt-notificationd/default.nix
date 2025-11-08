{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-notificationd";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-notificationd";
    rev = version;
    hash = "sha256-VmPVGqCmkTkib2T5ysov1hUY3J74GTuXdJsn5Sivreo=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    layer-shell-qt
    liblxqt
    libqtxdg
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-notificationd";
    description = "LXQt notification daemon";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
