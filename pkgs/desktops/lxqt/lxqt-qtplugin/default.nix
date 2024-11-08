{ lib
, stdenv
, fetchFromGitHub
, cmake
, libdbusmenu-lxqt
, libdbusmenu ? null
, libfm-qt
, libqtxdg
, lxqt-build-tools
, gitUpdater
, qtbase
, qtsvg
, qttools
, wrapQtAppsHook
, version ? "2.0.0"
}:

stdenv.mkDerivation rec {
  pname = "lxqt-qtplugin";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = {
      "1.4.1" = "sha256-sp/LvQNfodMYQ4kNbBv4PTNfs38XjYLezuxRltZd4kc=";
      "2.0.0" = "sha256-o5iD4VzsbN81lwDZJuFj8Ugg1RP752M4unu3J5/h8g8=";
    }."${version}";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    (if lib.versionAtLeast version "2.0.0" then libdbusmenu-lxqt else libdbusmenu)
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
    maintainers = teams.lxqt.members;
  };
}
