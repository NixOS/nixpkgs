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
  gmenuharness,
  gtest,
  intltool,
  libsecret,
  libqofono,
  libqtdbusmock,
  libqtdbustest,
  lomiri-api,
  lomiri-url-dispatcher,
  networkmanager,
  ofono,
  pkg-config,
  python3,
  qtdeclarative,
  qtbase,
  qttools,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-network";
  version = "1.1.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-indicator-network";
    tag = finalAttrs.version;
    hash = "sha256-uLqPbbCBahUwj9ZG3Q7x+bXCl0yI6L7jBpg09DTrrpk=";
  };

  outputs = [
    "out"
    "dev"
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
    doxygen
    gettext
    intltool
    pkg-config
    qtdeclarative
    qttools # qdoc
    validatePkgConfig
  ];

  buildInputs = [
    cmake-extras
    dbus
    glib
    libqofono
    libsecret
    lomiri-api
    lomiri-url-dispatcher
    networkmanager
    ofono
    qtbase
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
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true) # just in case something needs it
    (lib.cmakeBool "BUILD_DOC" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Multiple tests spin up & speak to D-Bus, avoid cross-talk causing failures
  enableParallelChecking = false;

  postInstall = ''
    substituteInPlace $out/etc/dbus-1/services/com.lomiri.connectivity1.service \
      --replace-fail '/bin/false' '${lib.getExe' coreutils "false"}'
  '';

  passthru = {
    ayatana-indicators = {
      lomiri-indicator-network = [ "lomiri" ];
    };
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      startup = nixosTests.ayatana-indicators;
      lomiri = nixosTests.lomiri.desktop-ayatana-indicator-network;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Ayatana indiator exporting the network settings menu through D-Bus";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-indicator-network";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-indicator-network/-/blob/${
      if (!builtins.isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "lomiri-connectivity-qt1" ];
  };
})
