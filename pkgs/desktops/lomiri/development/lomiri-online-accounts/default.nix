{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  testers,
  accounts-qml-module,
  accounts-qt,
  cmake,
  ctestCheckHook,
  dbus-test-runner,
  gettext,
  json-glib,
  libapparmor,
  libnotify,
  libqtdbusmock,
  libqtdbustest,
  lomiri-ui-toolkit,
  mesa,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  qttools,
  signond,
  ubports-click,
  wrapQtAppsHook,
  xauth,
  xmldiff,
  xvfb-run,
  withDocumentation ? true,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-online-accounts";
  version = "0.20";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-online-accounts";
    rev = finalAttrs.version;
    hash = "sha256-vllZ0M5bgVfMrnHgCBshzhDFgAMNNt9tDp8+unxXUL4=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  patches = [
    # Remove when version > 0.20
    (fetchpatch {
      name = "0001-lomiri-online-accounts-Fix-API-version-substitution-in-qmldir-file.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-online-accounts/-/commit/b0bdc1a982d89c9072907c4c3af305a0d6677fb7.patch";
      hash = "sha256-1LDSxfZISzh7dtf7mA3V2BsuI9lMOjK2hOHJUtHJb94=";
    })
  ];

  postPatch = ''
    # QMake-returned value is from QMake's build environment
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'QT_INSTALL_QML ''${CMAKE_INSTALL_FULL_LIBDIR}/qt''${QT_VERSION}/qml' \
        'QT_INSTALL_QML ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}' \
      --replace-fail \
        'qmake -query QT_INSTALL_QML' \
        'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}'

    # So plugins can substitute the prefix for their installation
    substituteInPlace online-accounts-plugins/lib/LomiriOnlineAccountsPlugin/LomiriOnlineAccountsPlugin.pc.in \
      --replace-fail 'plugin_qml_dir=@ONLINE_ACCOUNTS_PLUGIN_DIR@' 'plugin_qml_dir=''${prefix}/share/lomiri-online-accounts/qml-plugins'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ]
  ++ lib.optionals withDocumentation [
    qttools # qdoc
  ];

  # TODO: accounts-qml-module & lomiri-ui-toolkit? Or via plugin wrapper?
  buildInputs = [
    accounts-qt
    json-glib # for ubports-click
    libapparmor
    libnotify
    qtbase
    qtdeclarative
    signond
    ubports-click
  ];

  nativeCheckInputs = [
    ctestCheckHook
    dbus-test-runner
    # LUITK sometimes needs a valid OpenGL context
    # https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    mesa.llvmpipeHook
    (python3.withPackages (ps: with ps; [ python-dbusmock ]))
    xauth
    xmldiff
    xvfb-run
  ];

  checkInputs = [
    accounts-qml-module
    libqtdbusmock
    libqtdbustest
    lomiri-ui-toolkit
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_DOC" withDocumentation) # needs qdoc
    (lib.cmakeBool "ENABLE_MIRCLIENT" false) # we use Mir 2.x
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" false)
    (lib.cmakeBool "ENABLE_QT6" withQt6)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Breaks test shutdown
  enableParallelChecking = false;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
      export QML2_IMPORT_PATH=${
        listToQtVar qtbase.qtQmlPrefix [
          accounts-qml-module
          lomiri-ui-toolkit
        ]
      }
    '';

  disabledTests = [
    # Known-bad after recent refactor, other test was already disabled by upstream
    # https://gitlab.com/ubports/development/core/lomiri-online-accounts/-/issues/5
    "functional_tests"
  ];

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Lomiri's simplified Online Accounts API";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-online-accounts";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-online-accounts/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-online-accounts-service";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "LomiriOnlineAccountsClient"
      "LomiriOnlineAccountsDaemon"
      "LomiriOnlineAccountsPlugin"
      "LomiriOnlineAccountsQt5"
    ];
  };
})
