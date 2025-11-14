{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libdbusmenu-lxqt,
  libfm-qt,
  libqtxdg,
  lxqt-build-tools,
  gitUpdater,
  qtbase,
  qtsvg,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-qtplugin";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-qtplugin";
    tag = finalAttrs.version;
    hash = "sha256-3rY9VpZKnl1E3ma1ioiKECpazeymQYVuXrLXhRL407o=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libdbusmenu-lxqt
    libfm-qt
    libqtxdg
    qtbase
    qtsvg
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "DESTINATION \"\''${QT_PLUGINS_DIR}" "DESTINATION \"$qtPluginPrefix"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-qtplugin";
    description = "LXQt Qt platform integration plugin";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
})
