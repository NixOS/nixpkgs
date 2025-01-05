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
  version = "2.0.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-terminal-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-374ATxF+XhoALzYv6DEyj6IYgb82Ch4zcmqK0RXmlzI=";
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
    description = "Terminal app for desktop and mobile devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app";
    license = licenses.gpl3Only;
    mainProgram = "lomiri-terminal-app";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
