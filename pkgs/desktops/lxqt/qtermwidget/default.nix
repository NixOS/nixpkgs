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
  version ? "2.1.0",
}:

stdenv.mkDerivation rec {
  pname = "qtermwidget";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash =
      {
        "1.4.0" = "sha256-wYUOqAiBjnupX1ITbFMw7sAk42V37yDz9SrjVhE4FgU=";
        "2.1.0" = "sha256-I8fVggCi9qN+Jpqb/EC5/DfwuhGF55trbPESZQWPZ5M=";
      }
      ."${version}";
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
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "Terminal emulator widget for Qt, used by QTerminal";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
