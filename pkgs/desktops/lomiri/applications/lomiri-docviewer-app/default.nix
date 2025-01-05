{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  fetchpatch2,
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
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-docviewer-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zesBZmaMiMJwHtj3SoaNeHPiM9VNGEa4nTIiG8nskqI=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/76 merged & in release
    # fetchpatch2 because there's a file rename
    (fetchpatch2 {
      name = "1041-lomiri-docviewer-app-Configurable-LibreOffice-path.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/6e1aee99b31b88a90b07f3c5fcf6340c54ce9aaa.patch";
      hash = "sha256-KdHyKXM0hMMIFkuDn5JZJOEuitWAXT2QQOuR+1AolP0=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/81 merged & in release
    (fetchpatch {
      name = "1051-lomiri-docviewer-app-XDGify-icon.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/a319e648ba15a7868d9ceb3a77ea15ad196e515b.patch";
      hash = "sha256-JMSnN8EyWPHhqHzaJxy3JIhNaOvPLYkVDnNCrPGbO4E=";
    })
  ];

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
    maintainers = lib.teams.lomiri.members;
    mainProgram = "lomiri-docviewer-app";
    platforms = lib.platforms.linux;
  };
})
