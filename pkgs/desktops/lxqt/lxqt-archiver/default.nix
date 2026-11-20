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
  qtbase,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-archiver";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    hash = "sha256-Nvko9uwjI4+bM5d0iIzD5kWkqU+SFVfgnTNIadYsMqU=";
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
