{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  pkg-config,
  polkit,
  polkit-qt-1,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-policykit";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-policykit";
    rev = version;
    hash = "sha256-e9m8QKP6C6dOBVMZWaf9YjZwqfVD7qpGxdUZL07aT4c=";
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
    polkit
    polkit-qt-1
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-policykit";
    description = "LXQt PolicyKit agent";
    mainProgram = "lxqt-policykit-agent";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
}
