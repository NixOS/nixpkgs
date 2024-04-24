{ lib
, stdenv
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtbase
, qtermwidget
, qttools
, qtx11extras
, wrapQtAppsHook
, gitUpdater
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "qterminal";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-nojNx351lYw0jVKEvzAIDP1WrZWcCAlfYMxNG95GcEo=";
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
    qtx11extras
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
