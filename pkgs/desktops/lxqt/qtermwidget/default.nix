{ stdenv
, lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qttools
, lxqt-build-tools
, gitUpdater
}:

mkDerivation rec {
  pname = "qtermwidget";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-wYUOqAiBjnupX1ITbFMw7sAk42V37yDz9SrjVhE4FgU=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "A terminal emulator widget for Qt 5";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
