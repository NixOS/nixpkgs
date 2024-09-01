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
  dbus-test-runner,
  gettext,
  json-glib,
  libapparmor,
  libnotify,
  libqtdbusmock,
  libqtdbustest,
  lomiri-ui-toolkit,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  signond,
  ubports-click,
  wrapQtAppsHook,
  xauth,
  xmldiff,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-online-accounts";
  version = "0.15";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-online-accounts";
    rev = finalAttrs.version;
    hash = "sha256-FXbRDbwYCZ1x3csMP6I8/HhKTBoKya0jOboc4wQcfhE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/lomiri-online-accounts/-/merge_requests/15 merged & in release
    (fetchpatch {
      name = "0001-lomiri-online-accounts-OnlineAccountsPlugin-Call-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-online-accounts/-/commit/87420378c2e6b6555af920b209791f3c16bd7290.patch";
      hash = "sha256-FzDuyu0FHWtNeryYk3X4C9sJaxEG9WrXq3mb7ftZCTo=";
    })
  ];

  postPatch = ''
    # QMake-returned value is from QMake's build environment
    substituteInPlace CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}'

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
  ];

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
    dbus-test-runner
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
    (lib.cmakeBool "ENABLE_DOC" false) # needs qdoc
    (lib.cmakeBool "ENABLE_MIRCLIENT" false) # we use Mir 2.x
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Known-bad after recent refactor, other test was already disabled by upstream
            # https://gitlab.com/ubports/development/core/lomiri-online-accounts/-/issues/5
            "^functional_tests"

            # Runs into ShapeMaterial codepath in lomiri-ui-toolkit which needs OpenGL, see LUITK for details
            "^tst_qmlplugin"
          ]
        })")
      ]
    ))
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
        listToQtVar qtbase.qtQmlPrefix (
          [
            accounts-qml-module
            lomiri-ui-toolkit
          ]
          ++ lomiri-ui-toolkit.propagatedBuildInputs
        )
      }
    '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Lomiri's simplified Online Accounts API";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-online-accounts";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-online-accounts/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-online-accounts-service";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "LomiriOnlineAccountsClient"
      "LomiriOnlineAccountsDaemon"
      "LomiriOnlineAccountsPlugin"
      "LomiriOnlineAccountsQt5"
    ];
  };
})
