{ stdenv
, lib
, fetchFromGitHub
, cmake
, qtbase
, qttools
, lxqt-build-tools
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "qtermwidget";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-kZS6D/wSJFRt/+Afq0zCCmNnJPpFT+1hd4zVPc+rJsE=";
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
