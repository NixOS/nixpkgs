{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, nixosTests
, cmake
, gsettings-qt
, lomiri-ui-extras
, lomiri-ui-toolkit
, pkg-config
, qmltermwidget
, qtbase
, qtdeclarative
, qtsystems
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-terminal-app";
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-terminal-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mXbPmVcl5dL78QUp+w3o4im5ohUQCPTKWLSVqlNO0yo=";
  };

  patches = [
    # Fix CMake code not using the (intended? correct? working?) mechanism for depending on Qt modules
    ./0001-Drop-deprecated-qt5_use_modules.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" '${qtbase.qtQmlPrefix}' \
      --replace "\''${CMAKE_INSTALL_PREFIX}/\''${DATA_DIR}" "\''${CMAKE_INSTALL_FULL_DATADIR}/lomiri-terminal-app" \
      --replace 'EXEC "''${APP_NAME}"' 'EXEC "${placeholder "out"}/bin/''${APP_NAME}"'

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
    "-DINSTALL_TESTS=OFF"
    "-DCLICK_MODE=OFF"
  ];

  passthru = {
    tests.vm-test = nixosTests.terminal-emulators.lomiri-terminal-app;
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "A terminal app for desktop and mobile devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
