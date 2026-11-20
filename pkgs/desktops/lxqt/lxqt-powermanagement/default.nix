{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kidletime,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  lxqt-globalkeys,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  solid,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-powermanagement";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-powermanagement";
    rev = version;
    hash = "sha256-0ifvACsL/NLJlqhuif3OXuMDqRVS28f5L2ucxS1ENvs=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kidletime
    kwindowsystem
    liblxqt
    libqtxdg
    lxqt-globalkeys
    qtbase
    qtsvg
    qtwayland
    solid
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-powermanagement";
    description = "Power management module for LXQt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
}
