{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  lxqt-build-tools,
  json-glib,
  libexif,
  libfm-qt,
  menu-cache,
  qtbase,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-archiver";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    hash = "sha256-a3NdU1OZI+BqtvpUhqhwylf5upFJxeg8B+1cPTAdDr4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    json-glib
    libexif
    libfm-qt
    menu-cache
    qtbase
    qtwayland
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-archiver/";
    description = "Archive tool for the LXQt desktop environment";
    mainProgram = "lxqt-archiver";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jchw ] ++ teams.lxqt.members;
  };
}
