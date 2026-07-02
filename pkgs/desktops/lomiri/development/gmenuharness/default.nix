{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  dbus,
  dbus-test-runner,
  glib,
  gtest,
  libqtdbustest,
  lomiri-api,
  pkg-config,
  qtbase,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gmenuharness";
  version = "0.1.5";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/gmenuharness";
    rev = finalAttrs.version;
    hash = "sha256-hPlCetQ+2gmRdOoVQg7dIndiTxPEKgf8JJtZlihyIYA=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/gmenuharness/-/merge_requests/10 merged & in release
    ./1001-gmenuharness-Fix-order-of-cmake_minimum_required-and-project.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    glib
    lomiri-api
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
  ];

  checkInputs = [
    gtest
    libqtdbustest
    qtbase
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "enable_tests" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    (lib.strings.cmakeBool "ENABLE_QT6" withQt6)
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  checkPhase = ''
    runHook preCheck

    dbus-test-runner -t make -p test -p "''${enableParallelChecking:+-j $NIX_BUILD_CORES}"

    runHook postCheck
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Library to test GMenuModel structures";
    homepage = "https://gitlab.com/ubports/development/core/gmenuharness";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "libgmenuharness"
    ];
  };
})
