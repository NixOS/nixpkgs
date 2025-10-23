{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-qtplugin";
    tag = finalAttrs.version;
    hash = "sha256-qXadz9JBk4TURAWj6ByP/lGV1u0Z6rNJ/VraBh5zY+Q=";
  };

  patches = [
    # fix build against Qt >= 6.10 (https://github.com/lxqt/lxqt-qtplugin/pull/100)
    # TODO: drop when upgrading beyond version 2.2.0
    (fetchpatch {
      name = "cmake-fix-build-with-Qt-6.10.patch";
      url = "https://github.com/lxqt/lxqt-qtplugin/commit/90473945206dbf21816a00dfba27426a5b5a9e25.patch";
      hash = "sha256-cCghOJHsveR5IYisEFv3h8WreRDi0kuyj/2YBD+ATsc=";
    })
  ];

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
