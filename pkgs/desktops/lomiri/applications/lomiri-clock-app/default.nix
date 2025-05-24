{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  geonames,
  gettext,
  libusermetrics,
  lomiri-content-hub,
  lomiri-sounds,
  lomiri-ui-toolkit,
  makeWrapper,
  mesa,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtpositioning,
  qtsystems,
  runtimeShell,
  u1db-qt,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-clock-app";
  version = "4.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-clock-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5o+Y+10oM6k20I9fH1MB/9nzI143u0RJ/wHNIsrvaL0=";
  };

  postPatch = ''
    # QT_IMPORTS_DIR returned by qmake -query is broken
    substituteInPlace CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}' \

    # We don't want absolute paths in desktop files
    substituteInPlace lomiri-clock-app.desktop.in.in \
      --replace-fail '@ICON@' 'lomiri-clock-app' \
      --replace-fail '@SPLASH@' 'lomiri-app-launch/splash/lomiri-clock-app.svg'

    # Path to alarm sounds
    # TODO maybe change to /run/current-system/sw instead to pick up all installed sounds?
    substituteInPlace app/alarm/AlarmSound.qml backend/modules/Alarm/sound.cpp \
      --replace-fail '/usr' '${lomiri-sounds}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    makeWrapper
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    geonames
    qtbase

    # QML
    libusermetrics
    lomiri-content-hub
    lomiri-ui-toolkit
    qtdeclarative
    qtmultimedia
    qtpositioning
    qtsystems
    u1db-qt
  ];

  nativeCheckInputs = [
    mesa.llvmpipeHook # ShapeMaterial needs an OpenGL context: https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    qtdeclarative # qmltestrunner
    xvfb-run
  ];

  dontWrapGApps = true;

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "USE_XVFB" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
      export QML2_IMPORT_PATH=${
        listToQtVar qtbase.qtQmlPrefix (
          [
            lomiri-content-hub
            lomiri-ui-toolkit
            qtmultimedia
            u1db-qt
          ]
          ++ lomiri-ui-toolkit.propagatedBuildInputs
        )
      }
    '';

  # Parallelism breaks xvfb-run usage
  enableParallelChecking = false;

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/lomiri-clock-app/clock-app.svg $out/share/icons/hicolor/scalable/apps/lomiri-clock-app.svg
    ln -s $out/share/lomiri-clock-app/clock-app-splash.svg $out/share/lomiri-app-launch/splash/lomiri-clock-app.svg
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-clock-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Simple and easy to use clock for Ubuntu Touch, with time zone support for cities and timer and count down functions";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-clock-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    mainProgram = "lomiri-clock-app";
    platforms = lib.platforms.linux;
  };
})
