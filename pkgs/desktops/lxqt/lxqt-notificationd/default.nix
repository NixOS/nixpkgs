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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-L2eXab1V2t7+h51wEh0p2Uzdc3ImR4euoiXVVJ8BguA=";
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
    maintainers = teams.lxqt.members;
  };
}
