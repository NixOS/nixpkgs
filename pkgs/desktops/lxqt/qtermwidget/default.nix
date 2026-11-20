{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  qttools,
  lxqt-build-tools,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtermwidget";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qtermwidget";
    rev = finalAttrs.version;
    hash = "sha256-aQdk01vnyFC7J8zEIvIMcNgSM/cAfoX1SeaH/naKbzY=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "Terminal emulator widget for Qt, used by QTerminal";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
  };
})
