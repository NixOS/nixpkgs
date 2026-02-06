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
  qtfeedback,
  qtgraphicaleffects,
  qttools,
  validatePkgConfig,
  wrapGAppsHook3,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-content-hub";
  version = "2.2.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-content-hub";
    tag = finalAttrs.version;
    hash = "sha256-ukaEur2RgdIVPYm90OUCs0L+F9OQ3zaypreyx33iD5M=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "examples"
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
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qtdeclarative # qmlplugindump
    qttools # qdoc
    validatePkgConfig
    wrapGAppsHook3
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
    (lib.cmakeBool "ENABLE_QT6" (lib.strings.versionAtLeast qtbase.version "6"))
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_DOC" true)
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true) # in case something still depends on it
    (lib.cmakeBool "ENABLE_WERROR" true)
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
        listToQtVar [
          qtdeclarative
          lomiri-ui-toolkit
          qtfeedback
          qtgraphicaleffects
        ] qtbase.qtQmlPrefix
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
      "liblomiri-content-hub"
      "liblomiri-content-hub-glib"
    ];
  };
})
