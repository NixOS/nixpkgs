{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  gsettings-qt,
  lomiri-ui-extras,
  lomiri-ui-toolkit,
  pkg-config,
  qmltermwidget,
  qtbase,
  qtdeclarative,
  qtsystems,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-terminal-app";
  version = "2.0.5";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-terminal-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-STL8Km5NVSW3wEjC96sT4Q9z/lTSYKFQ6ku6M+CKM78=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Tests look abandoned - add_test in CMake code is commented out, refers to old repo structure in import paths
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qmltermwidget

    # QML
    gsettings-qt
    lomiri-ui-extras
    lomiri-ui-toolkit
    qtsystems
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "CLICK_MODE" false)
  ];

  passthru = {
    tests = {
      # The way the test works sometimes causes segfaults in qtfeedback
      # https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/issues/117
      # vm-test = nixosTests.terminal-emulators.lomiri-terminal-app;
      inherit (nixosTests.lomiri) desktop-basics desktop-appinteractions;
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Terminal app for desktop and mobile devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-terminal-app";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
