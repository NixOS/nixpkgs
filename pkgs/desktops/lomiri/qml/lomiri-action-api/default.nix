{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, cmake
, dbus
, dbus-test-runner
, pkg-config
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-action-api";
  version = "1.1.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-action-api";
    rev = finalAttrs.version;
    hash = "sha256-FOHjZ5F4IkjSn/SpZEz25CbTR/gaK4D7BRxDVSDuAl8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Drop deprecated qt5_use_modules usage
    # Remove when https://gitlab.com/ubports/development/core/lomiri-action-api/-/merge_requests/4 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/lomiri-action-api/-/commit/ff1d7f7eb127f6a00a99e8b278c963899d0303f0.patch";
      hash = "sha256-nLUoRl260hMbtEPjOQJI/3w54xgFxjcxerAqNN5FU/0=";
    })
  ];

  postPatch = ''
    # Queries QMake for broken Qt variable: '/build/qtbase-<commit>/$(out)/$(qtQmlPrefix)'
    substituteInPlace qml/Lomiri/Action/CMakeLists.txt \
      --replace "\''${QT_IMPORTS_DIR}/Lomiri" '${qtbase.qtQmlPrefix}/Lomiri'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
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
    "-DENABLE_TESTING=${lib.boolToString finalAttrs.finalPackage.doCheck}"
    "-Duse_libhud2=OFF" # Use vendored libhud2, TODO package libhud2 separately?
    "-DGENERATE_DOCUMENTATION=OFF" # QML docs need qdoc, https://github.com/NixOS/nixpkgs/pull/245379
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

  meta = with lib; {
    description = "Allow applications to export actions in various forms to the Lomiri Shell";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-action-api";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-action-qt-1"
    ];
  };
})
