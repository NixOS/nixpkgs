{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  dbus,
  doxygen,
  gsettings-qt,
  gtest,
  intltool,
  json-glib,
  libapparmor,
  libqtdbustest,
  pkg-config,
  qdjango,
  qtbase,
  qtdeclarative,
  qtxmlpatterns,
  ubports-click,
  validatePkgConfig,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libusermetrics";
  version = "1.3.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/libusermetrics";
    rev = finalAttrs.version;
    hash = "sha256-jmJH5vByBnBqgQfyb7HNVe+eS/jHcU64R2dnvuLbqss=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Not submitted yet, waiting for decision on how CMake testing should be handled
    ./2001-Remove-custom-check-target.patch

    # Due to https://gitlab.com/ubports/development/core/libusermetrics/-/issues/8, we require knowledge about AppArmor availability at launch time
    # Custom patch to launch a module-defined service that can handle this
    ./2002-Launch-module-created-systemd-service.patch
  ];

  postPatch = ''
    # Tries to query QMake for QT_INSTALL_QML variable, would return broken paths into /build/qtbase-<commit> even if qmake was available
    substituteInPlace src/modules/UserMetrics/CMakeLists.txt \
      --replace 'query_qmake(QT_INSTALL_QML QT_IMPORTS_DIR)' 'set(QT_IMPORTS_DIR "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}")'

    substituteInPlace doc/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_DATAROOTDIR}/doc/libusermetrics-doc" "\''${CMAKE_INSTALL_DOCDIR}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    intltool
    pkg-config
    validatePkgConfig
    wrapQtAppsHook
  ];

  buildInputs = [
    cmake-extras
    gsettings-qt
    json-glib
    libapparmor
    qdjango
    qtxmlpatterns
    ubports-click

    # Plugin
    qtbase
  ];

  nativeCheckInputs = [
    dbus
  ];

  checkInputs = [
    gtest
    libqtdbustest
    qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    (lib.cmakeBool "ENABLE_CLICK" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Flaky, randomly failing in UserMetricsImplTest.AddTranslatedData (data not ready when signal is emitted?)
            "^usermetricsoutput-unit-tests"
          ]
        })")
      ]
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/lib/qt-${qtbase.version}/plugins/
    export QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/lib/qt-${qtbase.version}/qml/
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Enables apps to locally store interesting numerical data for later presentation";
    homepage = "https://gitlab.com/ubports/development/core/libusermetrics";
    changelog = "https://gitlab.com/ubports/development/core/libusermetrics/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    mainProgram = "usermetricsinput";
    pkgConfigModules = [
      "libusermetricsinput-1"
      "libusermetricsoutput-1"
    ];
  };
})
