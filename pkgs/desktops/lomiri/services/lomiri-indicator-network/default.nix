{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, nixosTests
, testers
, cmake
, cmake-extras
, coreutils
, dbus
, doxygen
, gettext
, glib
, gmenuharness
, gtest
, intltool
, libsecret
, libqofono
, libqtdbusmock
, libqtdbustest
, lomiri-api
, lomiri-url-dispatcher
, networkmanager
, ofono
, pkg-config
, python3
, qtdeclarative
, qtbase
, validatePkgConfig
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-network";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-indicator-network";
    rev = finalAttrs.version;
    hash = "sha256-9AQCWCZFbt4XcmKsjoTXJlWOm02/kBhpPxbHRtftNFM=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    # Queried via pkg-config, would need to override a prefix variable
    # Needs CMake 3.28 or higher to do as part of the call, https://github.com/NixOS/nixpkgs/pull/275284
    substituteInPlace data/CMakeLists.txt \
      --replace 'pkg_get_variable(DBUS_SESSION_BUS_SERVICES_DIR dbus-1 session_bus_services_dir)' 'set(DBUS_SESSION_BUS_SERVICES_DIR "''${CMAKE_INSTALL_SYSCONFDIR}/dbus-1/services")' \
      --replace 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'set(SYSTEMD_USER_DIR "''${CMAKE_INSTALL_PREFIX}/lib/systemd/user")'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    intltool
    pkg-config
    qtdeclarative
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

  nativeCheckInputs = [
    (python3.withPackages (ps: with ps; [
      python-dbusmock
    ]))
  ];

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
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true) # just in case something needs it
    (lib.cmakeBool "BUILD_DOC" true) # lacks QML docs, needs qdoc: https://github.com/NixOS/nixpkgs/pull/245379
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = ''
    substituteInPlace $out/etc/dbus-1/services/com.lomiri.connectivity1.service \
      --replace '/bin/false' '${lib.getExe' coreutils "false"}'
  '';

  passthru = {
    ayatana-indicators = [
      "lomiri-indicator-network"
    ];
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      vm = nixosTests.ayatana-indicators;
    };
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Ayatana indiator exporting the network settings menu through D-Bus";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-indicator-network";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-indicator-network/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-connectivity-qt1"
    ];
  };
})
