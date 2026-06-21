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

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-push-qml";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-push-qml";
    tag = finalAttrs.version;
    hash = "sha256-+D8F0H3S+lfU53CJarE7Wrsc66JvJywzih0IgGD8cJo=";
  };

  postPatch =
    if (!withQt6) then
      ''
        # Queries QMake for QML install location, returns QtBase build path
        substituteInPlace src/*/PushNotifications/CMakeLists.txt \
          --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}'
      ''
    else
      ''
        substituteInPlace src/Lomiri/PushNotifications/CMakeLists.txt \
          --replace-fail \
            'set(QT_INSTALL_QML "''${CMAKE_INSTALL_LIBDIR}/qt6/qml/")' \
            'set(QT_INSTALL_QML "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}")'
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
    (lib.cmakeBool "ENABLE_QT6" withQt6)
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" (!withQt6))
  ];

  preBuild = ''
    # For qmlplugindump
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Lomiri Push Notifications QML plugin";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-push-qml";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-push-qml/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
