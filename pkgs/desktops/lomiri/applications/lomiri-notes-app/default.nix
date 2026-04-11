{
  stdenv,
  lib,
  fetchFromGitLab,
  unstableGitUpdater,
  accounts-qml-module,
  boost,
  cmake,
  gettext,
  lomiri-content-hub,
  lomiri-indicator-network,
  lomiri-online-accounts-unwrapped,
  lomiri-push-qml,
  lomiri-ui-toolkit,
  openssl,
  pkg-config,
  qqc2-suru-style,
  qtbase,
  qtdeclarative,
  qtpim,
  qtsvg,
  qtwebsockets,
  wrapQtAppsHook,
  writableTmpDirAsHomeHook,
  xvfb-run,
}:

let
  listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-notes-app";
  version = "1.0.1-unstable-2026-03-26";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-notes-app";
    rev = "4b8a3825b1a1710e2ccebde06a63463977bda4e5";
    hash = "sha256-w7Hy8IEHOaEwLi09/LzkvyjWWi39GY66a7GAyOrukF0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'QT_IMPORTS_DIR "''${CMAKE_INSTALL_LIBDIR}/qt5/qml"' 'QT_IMPORTS_DIR "${qtbase.qtQmlPrefix}"'
  ''
  # Needs to be in a different place, and named differently
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set(ACCOUNT_QML_PLUGIN_DIR ''${CMAKE_INSTALL_DATADIR}/accounts/qml-plugins)' \
        'set(ACCOUNT_QML_PLUGIN_DIR ''${CMAKE_INSTALL_DATADIR}/lomiri-online-accounts/qml-plugins)'

    substituteInPlace src/account-plugin/CMakeLists.txt \
      --replace-fail \
        'DESTINATION ''${ACCOUNT_QML_PLUGIN_DIR}/''${EVERNOTE_ACCOUNT_NAME}' \
        'DESTINATION ''${ACCOUNT_QML_PLUGIN_DIR}/''${EVERNOTE_PROVIDER_ID}'
  ''
  + ''
    substituteInPlace tests/qml/CMakeLists.txt \
      --replace-fail 'NO_DEFAULT_PATH' ""

    substituteInPlace tests/qml/tst_NotebooksDelegate.qml \
      --replace-fail 'delegate: NotebooksDelegate' 'delegate: NotebookDelegate'
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(tests)' '#add_subdirectory(tests)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    openssl
    qtbase
    qtpim

    # Plugin
    qtsvg

    # QML
    accounts-qml-module
    lomiri-content-hub
    lomiri-indicator-network
    lomiri-online-accounts-unwrapped
    lomiri-push-qml
    lomiri-ui-toolkit
    qqc2-suru-style
    qtwebsockets
  ];

  nativeCheckInputs = [
    qtdeclarative # qmltestrunner
    writableTmpDirAsHomeHook
    xvfb-run
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "CLICK_MODE" false)
    (lib.strings.cmakeBool "INSTALL_TESTS" false)
    (lib.strings.cmakeBool "USE_XVFB" true)
  ];

  # Tests seem broken, have been left disabled since 2022
  doCheck = false;

  # xvfb-run in parallel
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${
      listToQtVar qtbase.qtPluginPrefix [
        qtbase
        qtsvg
      ]
    }
    export QML2_IMPORT_PATH=${
      listToQtVar qtbase.qtQmlPrefix [
        accounts-qml-module
        lomiri-content-hub
        lomiri-indicator-network
        lomiri-online-accounts-unwrapped
        lomiri-push-qml
        lomiri-ui-toolkit
        qqc2-suru-style
        qtwebsockets
      ]
    }
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Advanced note taking application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-notes-app";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    mainProgram = "lomiri-notes-app";
  };
})
