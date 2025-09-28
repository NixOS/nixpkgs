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

stdenv.mkDerivation rec {
  pname = "lxqt-qtplugin";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-qtplugin";
    rev = version;
    hash = "sha256-qXadz9JBk4TURAWj6ByP/lGV1u0Z6rNJ/VraBh5zY+Q=";
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

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-qtplugin";
    description = "LXQt Qt platform integration plugin";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
