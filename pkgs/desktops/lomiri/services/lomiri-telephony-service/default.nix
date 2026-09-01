{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  runCommand,
  ayatana-indicator-messages,
  bash,
  cmake,
  dbus,
  dbus-glib,
  dbus-test-runner,
  dconf,
  gettext,
  glib,
  gnome-keyring,
  libnotify,
  libphonenumber,
  libpulseaudio,
  libusermetrics,
  lomiri-history-service,
  lomiri-url-dispatcher,
  makeWrapper,
  pkg-config,
  protobuf,
  python3,
  qtbase,
  qtdeclarative,
  qtfeedback,
  qtmultimedia,
  qtpim,
  telepathy,
  telepathy-glib,
  telepathy-mission-control,
  xvfb-run,
}:

let
  replaceDbusService =
    pkg: name:
    "--replace-fail \"\\\${DBUS_SERVICES_DIR}/${name}\" \"${pkg}/share/dbus-1/services/${name}\"";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-telephony-service";
  version = "0.6.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-telephony-service";
    tag = finalAttrs.version;
    hash = "sha256-CNtJPMust7zCuoXw/CpaK4NVXijTXA3Xs4YMJiZyxes=";
  };

  patches = [
    # Fixes for test flakiness & newer libnotify compatibility
    # Remove when version > 0.6.2
    (fetchpatch {
      name = "0001-lomiri-telephony-service-new-libnotify-needs-spec_version.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/6b0b51a4fcfafcd10ae5fe4928d49c9f73f14d12.patch";
      hash = "sha256-E9THrqE77GXBY8ftwrkwFzFCTSa/YpkaHiX4ivjH6mM=";
    })
    (fetchpatch {
      name = "0002-lomiri-telephony-service-tests-depend-on-the-notification-mock.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/8c5a3048492eb01354565f0892a61770eb27b957.patch";
      hash = "sha256-nLN+Evyq4Yf9GN2wSSPXmzEzTPXHDl+Pl5FKOiwdDY8=";
    })
    (fetchpatch {
      name = "0003-lomiri-telephony-service-approver-fix-race-condition-when-accepting-calls.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/b3123f784ed692f9424c978e68867a8662d00083.patch";
      hash = "sha256-/JEkoEEivFwFoNOrcdDleAGOjdUwS4SlUovMr9trNQQ=";
    })
    (fetchpatch {
      name = "0004-lomiri-telephony-service-Robustness-fixes-for-tests.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/e886fbdd016327634e935986f2b63b90833295be.patch";
      hash = "sha256-Ie9kM7UHSjmORTOTNzZ1/qtM4ILkOnGjyQCXXo1PU88=";
    })
  ];

  postPatch = ''
    # Queries qmake for the QML installation path, which returns a reference to Qt5's build directory
    # Patch out failure if QMake is not found, since we don't use it
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${QMAKE_EXECUTABLE} -query QT_INSTALL_QML" "echo $out/${qtbase.qtQmlPrefix}" \
      --replace-fail 'QMAKE_EXECUTABLE STREQUAL "QMAKE_EXECUTABLE-NOTFOUND"' 'FALSE'

  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    substituteInPlace tests/common/dbus-services/CMakeLists.txt \
      ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.MissionControl5.service"} \
      ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.AccountManager.service"} \
      ${replaceDbusService dconf "ca.desrt.dconf.service"}

    substituteInPlace cmake/modules/GenerateTest.cmake \
      --replace-fail '/usr/lib/dconf' '${lib.getLib dconf}/libexec' \
      --replace-fail '/usr/lib/telepathy' '${lib.getLib telepathy-mission-control}/libexec'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    ayatana-indicator-messages
    bash
    dbus-glib
    dbus
    dconf
    gettext
    glib
    libnotify
    libphonenumber
    libpulseaudio
    libusermetrics
    lomiri-history-service
    lomiri-url-dispatcher
    protobuf
    (python3.withPackages (
      ps: with ps; [
        dbus-python
        pygobject3
      ]
    ))
    qtbase
    qtdeclarative
    qtfeedback
    qtmultimedia
    qtpim
    telepathy
    telepathy-glib
    telepathy-mission-control
  ];

  nativeCheckInputs = [
    dbus-test-runner
    dconf
    gnome-keyring
    telepathy-mission-control
    xvfb-run
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # These rely on libphonenumber reformatting inputs to certain results
    # Seem to be broken for a small amount of numbers, maybe libphonenumber version change?
    (lib.cmakeBool "SKIP_QML_TESTS" true)
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev telepathy-glib}/include/telepathy-1.0" # it's in telepathy-farstream's Requires.private, so it & its dependencies don't get pulled in
    "-I${lib.getDev dbus-glib}/include/dbus-1.0" # telepathy-glib dependency
    "-I${lib.getDev dbus}/include/dbus-1.0" # telepathy-glib dependency
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Starts & talks to D-Bus services, breaks with parallelism
  enableParallelChecking = false;

  preCheck = ''
    export QT_QPA_PLATFORM=minimal
    export QT_PLUGIN_PATH=${
      lib.makeSearchPathOutput "bin" qtbase.qtPluginPrefix [
        qtbase
        qtpim
      ]
    }
  '';

  postInstall = ''
    patchShebangs $out/bin/{ofono-setup,phone-gsettings-migration.py}

    # Still missing getprop from libhybris, we don't have it packaged (yet?)
    wrapProgram $out/bin/ofono-setup \
      --prefix PATH : ${
        lib.makeBinPath [
          dbus
          dconf
          gettext
          glib
          telepathy-mission-control
        ]
      }

    # These SystemD services are referenced by the installed D-Bus services, but not part of the installation. Why?
    for service in lomiri-telephony-service-approver lomiri-indicator-telephony-service; do
      install -Dm644 ../debian/lomiri-telephony-service."$service".user.service $out/lib/systemd/user/"$service".service

      # ofono-setup.service would be provided by ubuntu-touch-session, we don't plan to package it
      # Doesn't make sense to provide on non-Lomiri
      substituteInPlace $out/lib/systemd/user/"$service".service \
        --replace-fail '/usr' "$out" \
        --replace-warn 'Requires=ofono-setup.service' "" \
        --replace-warn 'After=ofono-setup.service' "" \
        --replace-warn 'ayatana-indicators.target' 'lomiri-indicators.target'
    done

    # Parses the call & SMS indicator desktop files & tries to find its own executable in PATH
    wrapProgram $out/bin/lomiri-indicator-telephony-service \
      --prefix PATH : "$out/bin"
  '';

  passthru = {
    ayatana-indicators = {
      lomiri-indicator-telephony-service = [ "lomiri" ];
    };
    tests.vm = nixosTests.ayatana-indicators;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Backend dispatcher service for various mobile phone related operations";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-telephony-service";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
