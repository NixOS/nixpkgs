{
  stdenv,
  lib,
  fetchFromGitLab,
  testers,
  cmake,
  cmake-extras,
  dbus,
  dbus-test-runner,
  gtest,
  libqtdbustest,
  networkmanager,
  pkg-config,
  procps,
  python3,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqtdbusmock";
  version = "0.10.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/libqtdbusmock";
    rev = finalAttrs.version;
    hash = "sha256-6xOTqynuYmSpFJ8FJwKcTxhoddlSJuHuvlXRWmSjdeI=";
  };

  postPatch = ''
    # Workaround for "error: expected unqualified-id before 'public'" on "**signals"
    sed -i -e '/add_definitions/a -DQT_NO_KEYWORDS' CMakeLists.txt
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    # Don't build tests when we're not running them
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    libqtdbustest
    networkmanager
    qtbase
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
    procps
    (python3.withPackages (
      ps: with ps; [
        python-dbusmock
      ]
    ))
  ];

  checkInputs = [
    gtest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT6" (lib.strings.versionAtLeast qtbase.version "6"))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  checkPhase = ''
    runHook preCheck

    dbus-test-runner -t make -p test -p "''${enableParallelChecking:+-j $NIX_BUILD_CORES}"

    runHook postCheck
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Library for mocking DBus interactions using Qt";
    homepage = "https://gitlab.com/ubports/development/core/libqtdbusmock";
    changelog = "https://gitlab.com/ubports/development/core/libqtdbusmock/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.lomiri ];
    pkgConfigModules = [
      "libqtdbusmock-1"
    ];
  };
})
