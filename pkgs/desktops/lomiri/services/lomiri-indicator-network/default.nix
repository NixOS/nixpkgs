{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
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

  patches = [
    # Remove when version > 1.0.1
    (fetchpatch {
      name = "0001-lomiri-indicator-network-Make-less-assumptions-about-where-files-will-end-up.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-indicator-network/-/commit/065212b22ab9aa8d25a61b5482ad6511e4c8510b.patch";
      hash = "sha256-WrDTBKusK1808W8LZRGWaTOExu7gKpYBvkQ8hzoHoHk=";
    })

    # Remove when version > 1.0.1
    (fetchpatch {
      name = "0002-lomiri-indicator-network-Honour-CMAKE_INSTALL_DOCDIR_fordocumentation-installation.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-indicator-network/-/commit/79b9e12313f765ab6e95b4d4dfefbdbca50ef3c6.patch";
      hash = "sha256-vRfdegEi892UlrC9c1+5Td7CHLh7u0foPggLNBfc8lw=";
    })
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
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-connectivity-qt1"
    ];
  };
})
