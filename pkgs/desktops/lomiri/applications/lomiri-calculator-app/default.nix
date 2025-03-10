{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
  version = "4.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-calculator-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NyLEis+rIx2ELUiGrGCeFX/tlt43UgPBkb9aUs1tkgk=";
  };

  patches = [
    # Remove when version > 4.0.2
    (fetchpatch {
      name = "0001-lomiri-calculator-app-Fix-GNUInstallDirs-variable-concatenations.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calculator-app/-/commit/0bd6ef6c3470bcecf90a88e1e5568a5ce5ad6d06.patch";
      hash = "sha256-2FCLZ/LY3xTPGDmX+M8LiqlbcNQJu5hulkOf+V+3hWY=";
    })

    # Remove when version > 4.0.2
    # Must apply separately because merge has hunk with changes to new file before hunk that inits said file
    (fetchpatch {
      name = "0002-lomiri-calculator-app-Migrate-to-C++-app.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calculator-app/-/commit/035e5b8000ad1c8149a6b024fa8fed2667fbb659.patch";
      hash = "sha256-2BTFOrH/gjIzXBmnTPMi+mPpUA7e/+6O/E3pdxhjZYQ=";
    })
    (fetchpatch {
      name = "0003-lomiri-calculator-app-Call-i18n.bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calculator-app/-/commit/7cb5e56958e41a8f7a51e00d81d9b2bc24de32b0.patch";
      hash = "sha256-k/Civ0+SCNDDok9bUdb48FKC+LPlM13ASFP6CbBvBVs=";
    })
  ];

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
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-calculator-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-calculator-app";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
