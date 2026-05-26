{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  gettext,
  libreoffice-unwrapped,
  lomiri-content-hub,
  lomiri-ui-toolkit,
  pkg-config,
  poppler,
  qtbase,
  qtdeclarative,
  qtsystems,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-docviewer-app";
  version = "3.1.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-docviewer-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1urXLoya/ht7Ax0aqb0jQfyiJm6Z4sIKJn67MSwyNeo=";
  };

  postPatch = ''
    substituteInPlace cmake/modules/Click.cmake \
      --replace-fail 'qmake -query QT_INSTALL_QML' "echo $out/${qtbase.qtQmlPrefix}"

    # We don't want absolute paths in desktop files
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'SPLASH "''${DATA_DIR}/''${SPLASH_FILE}"' 'SPLASH "lomiri-app-launch/splash/lomiri-docviewer-app.svg"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libreoffice-unwrapped # LibreOfficeKit
    poppler
    qtbase
    qtdeclarative

    # QML
    lomiri-content-hub
    lomiri-ui-toolkit
    qtsystems
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeFeature "LIBREOFFICE_PREFIX" "${libreoffice-unwrapped}")
  ];

  # Only autopilot tests we can't run
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/lomiri-app-launch/splash

    ln -s $out/share/{lomiri-docviewer-app/docviewer-app-splash.svg,lomiri-app-launch/splash/lomiri-docviewer-app.svg}
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-docviewer-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Document Viewer application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    mainProgram = "lomiri-docviewer-app";
    platforms = lib.platforms.linux;
  };
})
