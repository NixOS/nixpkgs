{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  dbus,
  doxygen,
  glibcLocales,
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
  version = "1.3.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/libusermetrics";
    rev = finalAttrs.version;
    hash = "sha256-V4vxNyHMs2YYBILkpco79FN9xnooULgB+z2Kf3V0790=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/libusermetrics/-/merge_requests/17 merged & in release
    (fetchpatch {
      name = "0001-libusermetrics-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/core/libusermetrics/-/commit/c1e4847601cc4522034a766755ce491d48132d77.patch";
      hash = "sha256-UWc9/ngpuiSm0Rd6eBK/R3N/NwDRtMxie78seN3+y/8=";
    })
  ];

  postPatch = ''
    # Tries to query QMake for QT_INSTALL_QML variable, would return broken paths into /build/qtbase-<commit> even if qmake was available
    substituteInPlace src/modules/UserMetrics/CMakeLists.txt \
      --replace-fail 'query_qmake(QT_INSTALL_QML QT_IMPORTS_DIR)' 'set(QT_IMPORTS_DIR "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}")'

    substituteInPlace doc/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_FULL_DATAROOTDIR}/doc/libusermetrics-doc" "\''${CMAKE_INSTALL_DOCDIR}"
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

  # Tests need to be able to check locale
  LC_ALL = lib.optionalString finalAttrs.finalPackage.doCheck "en_US.UTF-8";

  nativeCheckInputs = [
    dbus
    glibcLocales
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

  meta = {
    description = "Enables apps to locally store interesting numerical data for later presentation";
    homepage = "https://gitlab.com/ubports/development/core/libusermetrics";
    changelog = "https://gitlab.com/ubports/development/core/libusermetrics/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    mainProgram = "usermetricsinput";
    pkgConfigModules = [
      "libusermetricsinput-1"
      "libusermetricsoutput-1"
    ];
  };
})
