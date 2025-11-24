{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  layer-shell-qt,
  lxqt-build-tools,
  qtbase,
  qtermwidget,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "qterminal";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qterminal";
    rev = version;
    hash = "sha256-HwWgVcO9swywei8Z3ifoGJjZ785gdF2A/kBHm4zgzFc=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    layer-shell-qt
    qtbase
    qtermwidget
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  passthru.tests.test = nixosTests.terminal-emulators.qterminal;

  meta = with lib; {
    homepage = "https://github.com/lxqt/qterminal";
    description = "Lightweight Qt-based terminal emulator";
    mainProgram = "qterminal";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
  };
}
