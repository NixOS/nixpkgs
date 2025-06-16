{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  makeFontsConf,
  testers,
  # dbus-cpp not compatible with Boost 1.87
  # https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp/-/issues/8
  boost186,
  cmake,
  cmake-extras,
  dbus,
  dbus-cpp,
  dbus-test-runner,
  doxygen,
  gettext,
  gflags,
  glog,
  gpsd,
  graphviz,
  gtest,
  json_c,
  libapparmor,
  net-cpp,
  pkg-config,
  process-cpp,
  properties-cpp,
  qtbase,
  qtlocation,
  trust-store,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-location-service";
  version = "3.3.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-location-service";
    tag = finalAttrs.version;
    hash = "sha256-zRRQzKKw72G2Rz8eL3lqjTcFDKC/mNHk+v5zgyiKdvQ=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    ./1001-treewide-Switch-to-upstream-glog-CMake-module.patch
  ];

  postPatch =
    ''
      substituteInPlace data/CMakeLists.txt \
        --replace-fail 'DESTINATION /etc' 'DESTINATION ''${CMAKE_INSTALL_SYSCONFDIR}' \
        --replace-fail 'DESTINATION /lib' 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
        --replace-fail 'DESTINATION /usr/lib' 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}'

      substituteInPlace data/lomiri-location-service-trust-stored.service.in \
        --replace-fail '@CMAKE_INSTALL_FULL_BINDIR@/trust-stored-skeleton' '${lib.getExe' trust-store "trust-stored-skeleton"}'

      substituteInPlace data/lomiri-location-service{,-connectivity}.pc.in \
        --replace-fail 'includedir=''${exec_prefix}/include' 'includedir=''${prefix}/include'

      substituteInPlace examples/service/lomiri-location-service.1 \
        --replace-fail '/usr/bin/lomiri\-location\-service/examples' "''${out//-/\\-}/libexec/examples"

      substituteInPlace qt/position/CMakeLists.txt \
        --replace-fail 'PLUGIN_INSTALL_LOCATION "''${CMAKE_INSTALL_LIBDIR}/qt5/plugins' 'PLUGIN_INSTALL_LOCATION "${qtbase.qtPluginPrefix}'

      substituteInPlace tests/CMakeLists.txt \
        --replace-fail 'DESTINATION /usr/libexec' 'DESTINATION ''${CMAKE_INSTALL_LIBEXECDIR}'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(tests)' '# add_subdirectory(tests)'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost186
    dbus
    dbus-cpp
    gflags
    glog
    gpsd
    json_c
    libapparmor
    net-cpp
    process-cpp
    properties-cpp
    qtbase
    qtlocation
    trust-store
  ];

  nativeCheckInputs = [
    dbus-test-runner
  ];

  checkInputs = [
    cmake-extras
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TRUST_STORE" true)
    # This is enabled by default, even if the needed hybris API is not found
    (lib.cmakeBool "LOCATION_SERVICE_ENABLE_GPS_PROVIDER" false)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      let
        disabledTests = [
          # Known-broken tests: https://gitlab.com/ubports/development/core/lomiri-location-service/-/issues/6
          # Above list is incomplete, check https://gitlab.com/ubports/development/core/lomiri-location-service/-/blob/c7b312a8a0c72df73f5038ffa45cf6bb93ead8c1/debian/rules#L55
          "acceptance_tests"
          "ichnaea_reporter_test"
          "remote_providerd_test"
          "delayed_service_test"
          "daemon_and_cli_tests"
        ];
      in
      lib.optionalString (lib.lists.length disabledTests > 0) (
        lib.concatStringsSep ";" [
          "-E"
          (lib.strings.escapeShellArg "^(${lib.concatStringsSep "|" disabledTests})")
        ]
      )
    ))
  ];

  # Makes fontconfig produce less noise in logs
  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };
  preBuild = ''
    export HOME=$TMPDIR
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Spins up D-Bus
  enableParallelChecking = false;

  # We don't want these to be installed, this is easier than patching out all the install calls
  postInstall = lib.optionalString finalAttrs.finalPackage.doCheck ''
    rm -r $out/libexec/lls-tests
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      # version is major.0.0
      versionCheck = false;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Location service aggregating position/velocity/heading";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-location-service";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-location-service/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    maintainers = lib.teams.lomiri.members;
    pkgConfigModules = [
      "lomiri-location-service"
      "lomiri-location-service-connectivity"
    ];
    platforms = lib.platforms.linux;
  };
})
