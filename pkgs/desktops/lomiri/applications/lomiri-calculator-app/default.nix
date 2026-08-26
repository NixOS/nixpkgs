{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  gettext,
  lomiri-ui-toolkit,
  pkg-config,
  qqc2-suru-style,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-calculator-app";
  version = "4.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-calculator-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RLg2B8LtYE3b7dRRvhPqIA4RAlwNO585q+02wBEedj8=";
  };

  postPatch =
    # We don't want absolute paths in desktop files
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'ICON ''${LOMIRI-CALCULATOR-APP_DIR}/''${ICON_FILE}' 'ICON ''${APP_HARDCODE}' \
        --replace-fail 'SPLASH ''${LOMIRI-CALCULATOR-APP_DIR}/''${SPLASH_FILE}' 'SPLASH lomiri-app-launch/splash/''${APP_HARDCODE}.svg'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(tests)' ""
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase

    # QML
    lomiri-ui-toolkit
    qqc2-suru-style
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
  ];

  # No tests we can actually run (just autopilot)
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/{lomiri-calculator-app,icons/hicolor/scalable/apps}/lomiri-calculator-app.svg
    ln -s $out/share/{lomiri-calculator-app/lomiri-calculator-app-splash.svg,lomiri-app-launch/splash/lomiri-calculator-app.svg}
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-calculator-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Powerful and easy to use calculator for Ubuntu Touch, with calculations history and formula validation";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-calculator-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-calculator-app/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-calculator-app";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
