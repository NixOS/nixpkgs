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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    hash = "sha256-57ufvirD1YYEVoFtX/JY8EnMRWZ4ouhbxNm8przg5XA=";
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

  meta = {
    homepage = "https://github.com/lxqt/lxqt-archiver/";
    description = "Archive tool for the LXQt desktop environment";
    mainProgram = "lxqt-archiver";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; unix;
    maintainers = with lib.maintainers; [ jchw ];
    teams = [ lib.teams.lxqt ];
  };
}
