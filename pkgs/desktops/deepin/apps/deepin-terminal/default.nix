{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  cmake,
  libsForQt5,
  pkg-config,
  libsecret,
  chrpath,
  lxqt,
}:

stdenv.mkDerivation rec {
  pname = "deepin-terminal";
  version = "6.0.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-Xcvdv58gJNhrdznQ09Nz/nMkM4IFIgQnapuhIdYHG0g=";
  };

  cmakeFlags = [ "-DVERSION=${version}" ];

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
    lxqt.lxqt-build-tools_0_13
  ];

  buildInputs = [
    qt5integration
    qt5platform-plugins
    libsForQt5.qtbase
    libsForQt5.qtsvg
    dtkwidget
    libsForQt5.qtx11extras
    libsecret
    chrpath
  ];

  strictDeps = true;

  passthru.tests.test = nixosTests.terminal-emulators.deepin-terminal;

  meta = {
    description = "Terminal emulator with workspace, multiple windows, remote management, quake mode and other features";
    mainProgram = "deepin-terminal";
    homepage = "https://github.com/linuxdeepin/deepin-terminal";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
