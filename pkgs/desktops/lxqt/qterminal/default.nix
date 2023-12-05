{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtermwidget
, qtbase
, qttools
, qtx11extras
, gitUpdater
, nixosTests
}:

mkDerivation rec {
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
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qtermwidget
  ];

  passthru.updateScript = gitUpdater { };

  passthru.tests.test = nixosTests.terminal-emulators.qterminal;

  meta = with lib; {
    homepage = "https://github.com/lxqt/qterminal";
    description = "A lightweight Qt-based terminal emulator";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; teams.lxqt.members;
  };
}
