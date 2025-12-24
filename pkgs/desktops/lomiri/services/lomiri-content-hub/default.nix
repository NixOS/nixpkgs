{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  testers,
  cmake,
  cmake-extras,
  dbus-test-runner,
  gettext,
  glib,
  gsettings-qt,
  gtest,
  libapparmor,
  libnotify,
  lomiri-api,
  lomiri-app-launch,
  lomiri-download-manager,
  lomiri-ui-toolkit,
  pkg-config,
  properties-cpp,
  qtbase,
  qtdeclarative,
  qtfeedback ? null,
  qtgraphicaleffects ? null,
  qttools,
  validatePkgConfig,
  wrapGAppsHook3,
  xvfb-run,
  withDocumentation ? true,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-content-hub";
  version = "2.2.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-content-hub";
    rev = finalAttrs.version;
    hash = "sha256-L0CX383AMu8XlNbGL01VvBxvawJwAWHhTh3ak0sjo20=";
  };

  outputs = [
    "out"
    "dev"
    "examples"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  postPatch = ''
    substituteInPlace import/*/Content/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Look for peer files in running system
    substituteInPlace src/com/lomiri/content/service/registry-updater.cpp \
      --replace-fail '/usr' '/run/current-system/sw'

    # Don't override default theme search path (which honours XDG_DATA_DIRS) with a FHS assumption
    substituteInPlace import/Lomiri/Content/contenthubplugin.cpp \
      --replace-fail 'QIcon::setThemeSearchPaths(QStringList() << ("/usr/share/icons/"));' ""

    # https://gitlab.com/ubports/development/core/lomiri-content-hub/-/merge_requests/54
    substituteInPlace src/com/lomiri/content/service/registry.h \
      --replace-fail '<QGSettings/QGSettings>' '<QGSettings>'
  ''
  # Need QtQuick.Window on QML2_IMPORT_PATH
  + ''
    substituteInPlace tests/qml6-tests/CMakeLists.txt \
      --replace-fail 'QML2_IMPORT_PATH=' 'QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}:'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qtdeclarative # qmlplugindump
    validatePkgConfig
    wrapGAppsHook3
  ]
  ++ lib.optionals withDocumentation [
    qttools # qdoc
  ];

  buildInputs = [
    cmake-extras
    glib
    gsettings-qt
    libapparmor
    libnotify
    lomiri-api
    lomiri-app-launch
    lomiri-download-manager
    lomiri-ui-toolkit
    properties-cpp
    qtbase
    qtdeclarative
    qtfeedback
    qtgraphicaleffects
  ];

  nativeCheckInputs = [
    dbus-test-runner
    xvfb-run
  ];

  checkInputs = [ gtest ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "ENABLE_QT6" withQt6)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_DOC" withDocumentation)
    # in case something still depends on it
    # no longer available in the Qt6 build
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" (!withQt6))
    (lib.cmakeBool "ENABLE_WERROR" (!withQt6)) # Known issues on Qt6
  ];

  preBuild =
    let
      listToQtVar =
        list: suffix: lib.strings.concatMapStringsSep ":" (drv: "${lib.getBin drv}/${suffix}") list;
    in
    ''
      # Executes qmlplugindump
      export QT_PLUGIN_PATH=${listToQtVar [ qtbase ] qtbase.qtPluginPrefix}
      export QML2_IMPORT_PATH=${
        listToQtVar (
          [
            qtdeclarative
            lomiri-ui-toolkit
          ]
          ++ lib.optionals (!withQt6) [
            qtfeedback
            qtgraphicaleffects
          ]
        ) qtbase.qtQmlPrefix
      }
    '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Starts & talks to D-Bus services, breaks under parallelism
  enableParallelChecking = false;

  preFixup = ''
    for exampleExe in lomiri-content-hub-test-{importer,exporter,sharer}; do
      moveToOutput bin/$exampleExe $examples
      moveToOutput share/applications/$exampleExe.desktop $examples
    done
    moveToOutput share/icons $examples
    moveToOutput share/lomiri-content-hub/peers $examples
  '';

  postFixup = ''
    for exampleBin in $examples/bin/*; do
      wrapGApp $exampleBin
    done
  '';

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      # Tests content-hub functionality, up to the point where one app receives a content exchange request
      # from another and changes into a mode to pick the content to send
      vm = nixosTests.lomiri.desktop-appinteractions;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Content sharing/picking service for the Lomiri desktop";
    longDescription = ''
      lomiri-content-hub is a mediation service to let applications share content between them,
      even if they are not running at the same time.
    '';
    homepage = "https://gitlab.com/ubports/development/core/lomiri-content-hub";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-content-hub/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    mainProgram = "lomiri-content-hub-service";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      ("liblomiri-content-hub" + lib.optionalString withQt6 "-qt6")
      "liblomiri-content-hub-glib"
    ];
  };
})
