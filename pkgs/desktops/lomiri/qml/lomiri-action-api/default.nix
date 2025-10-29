{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  dbus,
  dbus-test-runner,
  doxygen,
  pkg-config,
  qtbase,
  qtdeclarative,
  qttools,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-action-api";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-action-api";
    tag = finalAttrs.version;
    hash = "sha256-pwHvbiUvkAi7/XgpNfgrqcp3znFKSXlAAacB2XsHQkg=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    # Queries QMake for broken Qt variable: '/build/qtbase-<commit>/$(out)/$(qtQmlPrefix)'
    substituteInPlace qml/Lomiri/Action/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Fix section labels
    substituteInPlace documentation/qml/pages/* \
      --replace-warn '\part' '\section1'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    qtdeclarative
    qttools # qdoc
    validatePkgConfig
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT6" (lib.strings.versionAtLeast qtbase.version "6"))
    (lib.cmakeBool "ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "GENERATE_DOCUMENTATION" true)
    # Use vendored libhud2, TODO package libhud2 separately?
    (lib.cmakeBool "use_libhud2" false)
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Allow applications to export actions in various forms to the Lomiri Shell";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-action-api";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-action-api/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "lomiri-action-qt-1" ];
  };
})
