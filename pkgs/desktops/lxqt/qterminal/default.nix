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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "/R/fv8UAOeCVvXXBAXjturTTmN/LeqLKFJjAmEry2WU=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
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
    maintainers = with maintainers; [ globin ] ++ teams.lxqt.members;
  };
}
