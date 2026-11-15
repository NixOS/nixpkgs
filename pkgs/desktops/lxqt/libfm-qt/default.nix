{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libxdmcp,
  libexif,
  libfm,
  libpthread-stubs,
  libxcb,
  lxqt-build-tools,
  lxqt-menu-data,
  menu-cache,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfm-qt";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    tag = finalAttrs.version;
    hash = "sha256-gfyskv/TpAdBES0+O1MrrkQqTDqtAGtDMIwv3NF7pnE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libxdmcp
    libexif
    libfm
    libpthread-stubs
    libxcb
    lxqt-menu-data
    menu-cache
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/libfm-qt";
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.lxqt ];
  };
})
