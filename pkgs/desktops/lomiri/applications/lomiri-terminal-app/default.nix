{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-terminal-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mXbPmVcl5dL78QUp+w3o4im5ohUQCPTKWLSVqlNO0yo=";
  };

  patches = [
    # Stop usage of private qt5_use_modules function, seemingly unavailable in this package
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/merge_requests/103 merged & in release
    (fetchpatch {
      name = "0001-lomiri-terminal-app-Stop-using-qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/commit/db210c74e771a427066aebdc3a99cab6e782d326.patch";
      hash = "sha256-op4+/eo8rBRMcW6MZ0rOEFReM7JBCck1B+AsgAPyqAI=";
    })

    # Explicitly bind textdomain, don't rely on hacky workaround in LUITK
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/merge_requests/104 merged & in release
    (fetchpatch {
      name = "0002-lomiri-terminal-app-Call-i18n.bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/commit/7f9d419e29043f0d0922d2ac1dce5673e2723a01.patch";
      hash = "sha256-HfIvGVbIdTasoHAfHysnzFLufQQ4lskym5HTekH+mjk=";
    })

    # Add more & correct existing usage of GNUInstallDirs variables
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/merge_requests/105 merged & in release
    (fetchpatch {
      name = "0003-lomiri-terminal-app-GNUInstallDirs-usage.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app/-/commit/fcde1f05bb442c74b1dff95917fd7594f26e97a7.patch";
      hash = "sha256-umxCMGNjyz0TVmwH0Gl0MpgjLQtkW9cHkUfpNJcoasE=";
    })
  ];

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
    description = "A terminal app for desktop and mobile devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-terminal-app";
    license = licenses.gpl3Only;
    mainProgram = "lomiri-terminal-app";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
