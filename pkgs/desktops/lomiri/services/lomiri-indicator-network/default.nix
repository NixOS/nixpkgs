{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  testers,
  cmake,
  cmake-extras,
  coreutils,
  dbus,
  doxygen,
  gettext,
  glib,
  gmenuharness ? null, # not ported to Qt6 yet
  gtest,
  intltool,
  libsecret,
  libqofono ? null, # not ported to Qt6 yet
  libqtdbusmock,
  libqtdbustest,
  lomiri-api,
  lomiri-url-dispatcher,
  networkmanager,
  ofono,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  qttools,
  validatePkgConfig,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-network";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-indicator-network";
    tag = finalAttrs.version;
    hash = "sha256-BbG48sWlpcaSC0HTDcY+zbzi1O983FzzJ7B1oSlJrGg=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals (!withQt6) [
    "doc"
  ];

  postPatch = ''
    # Override original prefixes
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(DBUS_SESSION_BUS_SERVICES_DIR dbus-1 session_bus_services_dir)' 'pkg_get_variable(DBUS_SESSION_BUS_SERVICES_DIR dbus-1 session_bus_services_dir DEFINE_VARIABLES datadir=''${CMAKE_INSTALL_FULL_SYSCONFDIR})' \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qtdeclarative
    validatePkgConfig
  ]
  ++ lib.optionals (!withQt6) [
    doxygen
    intltool
    qttools # qdoc
  ];

  buildInputs = [
    cmake-extras
    lomiri-api
    qtbase
  ]
  ++ lib.optionals withQt6 [
    qtdeclarative
  ]
  ++ lib.optionals (!withQt6) [
    dbus
    glib
    libqofono
    libsecret
    lomiri-url-dispatcher
    networkmanager
    ofono
  ];

  nativeCheckInputs = [ (python3.withPackages (ps: with ps; [ python-dbusmock ])) ];

  checkInputs = [
    gmenuharness
    gtest
    libqtdbusmock
    libqtdbustest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOC" (!withQt6))
    # Indicator is not ported to Qt6 yet
    (lib.cmakeBool "BUILD_LIBCONNECTIVITY_ONLY" withQt6)
    (lib.cmakeBool "ENABLE_COVERAGE" false)
    (lib.cmakeBool "ENABLE_QT6" withQt6)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" (!withQt6))
    (lib.cmakeBool "GSETTINGS_COMPILE" (!withQt6))
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" (!withQt6))
    (lib.cmakeBool "USE_SYSTEMD" (!withQt6))
  ];

  doCheck =
    stdenv.buildPlatform.canExecute stdenv.hostPlatform
    # Indicator is not ported to Qt6 yet, tests only cover indicator
    && !withQt6;

  # Multiple tests spin up & speak to D-Bus, avoid cross-talk causing failures
  enableParallelChecking = false;

  postInstall = lib.optionalString (!withQt6) ''
    substituteInPlace $out/etc/dbus-1/services/com.lomiri.connectivity1.service \
      --replace-fail '/bin/false' '${lib.getExe' coreutils "false"}'
  '';

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    }
    // lib.optionalAttrs (!withQt6) {
      startup = nixosTests.ayatana-indicators;
      lomiri = nixosTests.lomiri.desktop-ayatana-indicator-network;
    };
    updateScript = gitUpdater { };
  }
  // lib.optionalAttrs (!withQt6) {
    ayatana-indicators = {
      lomiri-indicator-network = [ "lomiri" ];
    };
  };

  meta = {
    description = "Ayatana indiator exporting the network settings menu through D-Bus";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-indicator-network";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-indicator-network/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "lomiri-connectivity-qt${if withQt6 then "6" else "1"}" ];
  };
})
