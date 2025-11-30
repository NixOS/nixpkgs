{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  sudo,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-sudo";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-sudo";
    rev = version;
    hash = "sha256-skxPI6KEHXJReadxQinBArkCx/FjpTYDFdEpRRiqx8E=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qtbase
    qtsvg
    qtwayland
    sudo
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-sudo";
    description = "GUI frontend for sudo/su";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
