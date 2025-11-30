{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  cmake,
  lomiri-api,
  lomiri-indicator-network,
  pkg-config,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-push-qml";
  version = "0.3.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-push-qml";
    tag = finalAttrs.version;
    hash = "sha256-1HJkcAe5ixqmEACy4mSk5dSCPf4FsY3tzH6v09SSH+M=";
  };

  postPatch = ''
    # Queries QMake for QML install location, returns QtBase build path
    substituteInPlace src/*/PushNotifications/CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}' \
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
  ];

  buildInputs = [
    lomiri-api
    lomiri-indicator-network
    qtbase
    qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # In case anything still depends on deprecated hints
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true)
  ];

  preBuild = ''
    # For qmlplugindump
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Lomiri Push Notifications QML plugin";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-push-qml";
    # License file indicates gpl3Only, but de87869c2cdb9819c2ca7c9eca9c5fb8b500a01f says it should be lgpl3Only
    license = licenses.lgpl3Only;
    teams = [ teams.lomiri ];
    platforms = platforms.linux;
  };
})
