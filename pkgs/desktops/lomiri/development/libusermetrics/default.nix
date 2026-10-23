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
  version = "1.4.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/libusermetrics";
    rev = finalAttrs.version;
    hash = "sha256-WkQqMuPoDDzA2HwD+6YCS9ZigiGL8WGNRZ51ywGNm4s=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Upstream switched to building qdjango statically so users don't have to build & install a dead project.
    # Maybe https://gitlab.com/ubports/development/core/libusermetrics/-/merge_requests/24 will get rid of it for good.
    # Until then, undo & link against our system-installed build.
    (fetchpatch {
      name = "0001-libusermetrics-revert-qdjango-vendoring.patch";
      url = "https://gitlab.com/ubports/development/core/libusermetrics/-/commit/87f83dd4711bfb4e94fd87bc68403a9bd5cfef2a.patch";
      revert = true;
      includes = [
        "CMakeLists.txt"
        "src/usermetricsservice/CMakeLists.txt"
      ];
      hash = "sha256-OPTQPRr10I7bk7dQ/9x17mv42pKc8yIQUGEGak01Hic=";
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
  env.LC_ALL = lib.optionalString finalAttrs.finalPackage.doCheck "en_US.UTF-8";

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
