{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  boost,
  cmake,
  cmake-extras,
  dbus,
  dbus-test-runner,
  withDocumentation ? true,
  doxygen,
  glog,
  graphviz,
  gtest,
  libapparmor,
  lomiri-api,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  qttools,
  validatePkgConfig,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-download-manager";
  version = "0.2.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-download-manager";
    tag = finalAttrs.version;
    hash = "sha256-e4HyUi8GXImEtM5I7dH27cDceUn+VCFpb9xgbMpQBJU=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [ "doc" ];

  postPatch = ''
    # Substitute systemd's prefix in pkg-config call
    substituteInPlace CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Upstream code is to work around a bug, but it only seems to cause config issues for us
    substituteInPlace tests/common/CMakeLists.txt \
      --replace-fail 'add_dependencies(''${TARGET} GMock)' '# add_dependencies(''${TARGET} GMock)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
    wrapQtAppsHook
  ]
  ++ lib.optionals withDocumentation [
    doxygen
    graphviz
    qttools # qdoc
  ];

  buildInputs = [
    boost
    cmake-extras
    glog
    libapparmor
    lomiri-api
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
    python3
    xvfb-run
  ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT6" (lib.strings.versionAtLeast qtbase.version "6"))
    (lib.cmakeBool "ENABLE_DOC" withDocumentation)
    (lib.cmakeBool "ENABLE_WERROR" true)
  ];

  makeTargets = [ "all" ] ++ lib.optionals withDocumentation [ "doc" ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # xvfb tests are flaky on xvfb shutdown when parallelised
  enableParallelChecking = false;

  preCheck = ''
    export HOME=$TMPDIR # temp files in home
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix} # xcb platform & sqlite driver
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Performs uploads and downloads from a centralized location";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-download-manager";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-download-manager/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "ldm-common"
      "lomiri-download-manager-client"
      "lomiri-download-manager-common"
      "lomiri-upload-manager-common"
    ];
  };
})
