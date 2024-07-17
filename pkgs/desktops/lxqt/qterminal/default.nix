{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-SesKJCiMoiqkvMM29+0IMERozQ9zuD+NJTtaC6j7ubM=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtermwidget
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  passthru.tests.test = nixosTests.terminal-emulators.qterminal;

  meta = with lib; {
    homepage = "https://github.com/lxqt/qterminal";
    description = "A lightweight Qt-based terminal emulator";
    mainProgram = "qterminal";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; teams.lxqt.members;
  };
}
