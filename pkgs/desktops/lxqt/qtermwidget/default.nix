{ stdenv
, lib
, fetchFromGitHub
, cmake
, qtbase
, qttools
, lxqt-build-tools
, wrapQtAppsHook
, gitUpdater
, version ? "2.0.0"
}:

stdenv.mkDerivation rec {
  pname = "qtermwidget";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = {
      "1.4.0" = "sha256-wYUOqAiBjnupX1ITbFMw7sAk42V37yDz9SrjVhE4FgU=";
      "2.0.0" = "sha256-kZS6D/wSJFRt/+Afq0zCCmNnJPpFT+1hd4zVPc+rJsE=";
    }."${version}";
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

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "A terminal emulator widget for Qt, used by QTerminal";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
