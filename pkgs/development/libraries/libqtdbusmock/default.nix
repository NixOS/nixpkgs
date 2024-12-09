{ stdenv
, lib
, fetchFromGitLab
, testers
, cmake
, cmake-extras
, dbus
, dbus-test-runner
, gtest
, libqtdbustest
, networkmanager
, pkg-config
, procps
, python3
, qtbase
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqtdbusmock";
  version = "0.9.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/libqtdbusmock";
    rev = finalAttrs.version;
    hash = "sha256-hVw2HnIHlA7vvt0Sr6F2qVhvBZ33aCeqb9vgbu3rgBo=";
  };

  postPatch = ''
    # Workaround for "error: expected unqualified-id before 'public'" on "**signals"
    sed -i -e '/add_definitions/a -DQT_NO_KEYWORDS' CMakeLists.txt
  '' + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
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
    (python3.withPackages (ps: with ps; [
      python-dbusmock
    ]))
  ];

  checkInputs = [
    gtest
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  checkPhase = ''
    runHook preCheck

    dbus-test-runner -t make -p test -p "''${enableParallelChecking:+-j $NIX_BUILD_CORES}"

    runHook postCheck
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Library for mocking DBus interactions using Qt";
    homepage = "https://launchpad.net/libqtdbusmock";
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = teams.lomiri.members;
    pkgConfigModules = [
      "libqtdbusmock-1"
    ];
  };
})
