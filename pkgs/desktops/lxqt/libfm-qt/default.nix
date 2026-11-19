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
  pkg-config,
  qttools,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfm-qt";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    tag = finalAttrs.version;
    hash = "sha256-mKn70TQt8/P94EVcHsLBansb0wQqWd4fIyDtI+STCpQ=";
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
