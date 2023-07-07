{ stdenv
, lib
, fetchbzr
, fetchpatch
, testers
, cmake
, cmake-extras
, dbus
, dbus-test-runner
, gtest
, pkg-config
, procps
, python3
, qtbase
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqtdbustest";
  version = "unstable-2017-01-06";

  src = fetchbzr {
    url = "lp:libqtdbustest";
    rev = "42";
    sha256 = "sha256-5MQdGGtEVE/pM9u0B0xFXyITiRln9p+8/MLtrrCZqi8=";
  };

  patches = [
    # Tests are overly pedantic when looking for launched process names in `ps`, break on python wrapper vs real python
    # Just check if basename + arguments match, like libqtdbusmock does
    ./less-pedantic-process-finding.patch

    # Disable QProcess start timeout
    (fetchpatch {
      url = "https://salsa.debian.org/debian-ayatana-team/libqtdbustest/-/raw/0788df10bc6f2aa47c2b73fc1df944686a9ace1e/debian/patches/1003_no-QProcess-waitForstarted-timeout.patch";
      hash = "sha256-ThDbn6URvkj5ARDMj+xO0fb1Qh2YQRzVy24O03KglHI=";
    })

    # More robust dbus address reading
    (fetchpatch {
      url = "https://salsa.debian.org/debian-ayatana-team/libqtdbustest/-/raw/7e55c79cd032c702b30d834c1fb0b65661fc6eeb/debian/patches/1004_make-reading-address-from-dbus-daemon-more-robust.patch";
      hash = "sha256-hq8pdducp/udxoGWGt1dgL/7VHcbJO/oT1dOY1zew8M=";
    })
  ];

  strictDeps = true;

  postPatch =  lib.optionalString (!finalAttrs.doCheck) ''
    # Don't build tests when we're not running them
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
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
    description = "Library for testing DBus interactions using Qt";
    homepage = "https://launchpad.net/libqtdbustest";
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = teams.lomiri.members;
    mainProgram = "qdbus-simple-test-runner";
    pkgConfigModules = [
      "libqtdbustest-1"
    ];
  };
})
