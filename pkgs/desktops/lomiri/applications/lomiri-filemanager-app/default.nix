{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  biometryd,
  cmake,
  gettext,
  lomiri-content-hub,
  lomiri-thumbnailer,
  lomiri-ui-extras,
  lomiri-ui-toolkit,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  samba,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-filemanager-app";
  version = "1.1.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-filemanager-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2NDz9XcUMEYHOLaomTVImjuQHLzZ/pat/Fe9uWe29as=";
  };

  postPatch = ''
    # Use correct QML install path, don't pull in autopilot test code (we can't run that system)
    # Remove absolute paths from desktop file, https://github.com/NixOS/nixpkgs/issues/308324
    substituteInPlace CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ${placeholder "out"}/${qtbase.qtQmlPrefix}' \
      --replace-fail 'add_subdirectory(tests)' '#add_subdirectory(tests)' \
      --replace-fail 'SPLASH ''${DATA_DIR}/''${SPLASH_FILE}' 'SPLASH lomiri-app-launch/splash/lomiri-filemanager-app.svg'

    # In case this ever gets run, at least point it to a correct-ish path
    substituteInPlace tests/autopilot/CMakeLists.txt \
      --replace-fail 'python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"' 'echo "${placeholder "out"}/${python3.sitePackages}/lomiri_filemanager_app"'
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
    qtdeclarative
    samba

    # QML
    biometryd
    lomiri-content-hub
    lomiri-thumbnailer
    lomiri-ui-extras
    lomiri-ui-toolkit
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "CLICK_MODE" false)
  ];

  # No tests we can actually run (just autopilot)
  doCheck = false;

  passthru = {
    tests.vm = nixosTests.lomiri-filemanager-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "File Manager application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-filemanager-app";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
