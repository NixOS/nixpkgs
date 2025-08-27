{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  flatbuffers,
  gettext,
  lomiri-indicator-network,
  lomiri-ui-toolkit,
  pyotherside,
  qtbase,
  qtdeclarative,
  qtlocation,
  qtpositioning,
  qtquickcontrols2,
  qtwebengine,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-weather-app";
  version = "6.1.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-weather-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N9OAPdEp0x9sOFt15OWWT50+OXmJVQAa8feVhx/3mTE=";
  };

  patches = [
    # Since flatbuffers 2.0.6, verifying the data received from openmeteo fails on an alignment check
    # even though actual decoding seems to work fine
    # https://gitlab.com/ubports/development/apps/lomiri-weather-app/-/issues/118
    # At our own risk, assume that the alignment is fine and disable that part of the checks
    ./2001-Disable-flatbuffers-alignment-check.patch
  ];

  postPatch =
    ''
      # Queries qmake for the QML installation path, which returns a reference to Qt5's build directory
      substituteInPlace CMakeLists.txt \
        --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}'

      # We don't want absolute paths in desktop files
      substituteInPlace lomiri-weather-app.desktop.in.in \
        --replace-fail 'Icon=@ICON@' 'Icon=lomiri-weather-app' \
        --replace-fail 'X-Lomiri-Splash-Image=@SPLASH@' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/lomiri-weather-app.svg'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(tests)' ""
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    wrapQtAppsHook
  ];

  buildInputs = [
    flatbuffers
    qtlocation
    qtquickcontrols2
    qtwebengine

    # QML
    lomiri-indicator-network
    lomiri-ui-toolkit
    pyotherside
    qtdeclarative
    qtpositioning
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
  ];

  # No tests we can actually run (just autopilot)
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/{lomiri-weather-app/weather-app,icons/hicolor/scalable/apps/lomiri-weather-app}.svg
    ln -s $out/share/{lomiri-weather-app/weather-app-splash,lomiri-app-launch/splash/lomiri-weather-app}.svg
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-weather-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Weather application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-weather-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-weather-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only # code
      cc-by-sa-40 # additional graphics
    ];
    mainProgram = "lomiri-weather-app";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
