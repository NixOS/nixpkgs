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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-network";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-indicator-network";
    rev = finalAttrs.version;
    hash = "sha256-rJKWhW082ndVPEQHjuSriKtl0zQw86adxiINkZQq1hY=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    # Patch FHS paths
    # DBUS_SESSION_BUS_SERVICES_DIR queried via pkg-config, prefix output path
    substituteInPlace data/CMakeLists.txt \
      --replace '/usr/lib/systemd/user' "$out/lib/systemd/user" \
      --replace '/etc/xdg/autostart' "$out/etc/xdg/autostart" \
      --replace 'DESTINATION "''${DBUS_SESSION_BUS_SERVICES_DIR}"' 'DESTINATION "''${CMAKE_INSTALL_PREFIX}/''${DBUS_SESSION_BUS_SERVICES_DIR}"'

    # Don't disregard GNUInstallDirs requests, {DOCDIR}/../<different-name> to preserve preferred name
    substituteInPlace doc/CMakeLists.txt \
      --replace 'INSTALL_DOCDIR ''${CMAKE_INSTALL_DATAROOTDIR}/doc/lomiri-connectivity-doc' 'INSTALL_DOCDIR ''${CMAKE_INSTALL_DOCDIR}/../lomiri-connectivity-doc'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    intltool
    pkg-config
    qtdeclarative
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
    "-DGSETTINGS_LOCALINSTALL=ON"
    "-DGSETTINGS_COMPILE=ON"
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.doCheck}"
    "-DENABLE_UBUNTU_COMPAT=ON" # in case
    "-DBUILD_DOC=ON" # lacks QML docs, needs qdoc: https://github.com/NixOS/nixpkgs/pull/245379
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
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-connectivity-qt1"
    ];
  };
})
