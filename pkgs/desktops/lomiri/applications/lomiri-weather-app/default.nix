{
  stdenv,
  lib,
  fetchFromGitLab,
  unstableGitUpdater,
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
  qtwebengine,
  wrapQtAppsHook,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-weather-app";
  version = "6.2.0-unstable-2026-03-21";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-weather-app";
    rev = "9755e9f4d53767a254ddc025170b622c2aebfd8e";
    hash = "sha256-vESMGTmRVZMfArBYXNH7VVpPDvbgDT+Ti3nvNf27krM=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-weather-app/-/merge_requests/147 merged & in release
    ./1001-treewide-Port-to-Qt6.patch
  ];

  postPatch =
    # Queries qmake for the QML installation path, which returns a reference to Qt5's build directory
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "\''${QMAKE_EXECUTABLE} -query QT_INSTALL_QML" 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}'
    ''
    # We don't want absolute paths in desktop files
    + ''
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
    qtwebengine

    # QML
    lomiri-indicator-network # still imported, even when opted out of
    lomiri-ui-toolkit
    pyotherside
    qtdeclarative
    qtpositioning
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "ENABLE_QT6" withQt6)
    (lib.strings.cmakeBool "CLICK_MODE" false)
    (lib.strings.cmakeBool "INSTALL_TESTS" false)
    (lib.strings.cmakeBool "CONNECTIVITY_CHECK" false) # Makes running outside of Lomiri possible
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
    updateScript = unstableGitUpdater { tagPrefix = "v"; };
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
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
