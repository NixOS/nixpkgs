{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, nixosTests
, ayatana-indicator-messages
, bash
, cmake
, dbus
, dbus-glib
, dbus-test-runner
, dconf
, gettext
, glib
, gnome
, history-service
, libnotify
, libphonenumber
, libpulseaudio
, libusermetrics
, lomiri-url-dispatcher
, makeWrapper
, pkg-config
, protobuf
, python3
, qtbase
, qtdeclarative
, qtfeedback
, qtmultimedia
, qtpim
, telepathy
, telepathy-glib
, telepathy-mission-control
, xvfb-run
}:

let
  replaceDbusService = pkg: name: "--replace \"\\\${DBUS_SERVICES_DIR}/${name}\" \"${pkg}/share/dbus-1/services/${name}\"";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "telephony-service";
  version = "0.5.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/telephony-service";
    rev = finalAttrs.version;
    hash = "sha256-eLGwAJmBDDvSODQUNr/zcPA/0DdXtVBiS7vg+iIYPDo=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/telephony-service/-/merge_requests/90 merged & in release
    (fetchpatch {
      name = "0001-telephony-service-CMakeLists-Make-tests-optional.patch";
      url = "https://gitlab.com/ubports/development/core/telephony-service/-/commit/9a8297bcf9b34d77ffdae3dfe4ad2636022976fb.patch";
      hash = "sha256-Za4ZGKnw9iz2RP1LzLhKrEJ1vLUufWk8J07LmWDW40E=";
    })
  ];

  postPatch = ''
    # Queries qmake for the QML installation path, which returns a reference to Qt5's build directory
    substituteInPlace CMakeLists.txt \
      --replace "\''${QMAKE_EXECUTABLE} -query QT_INSTALL_QML" "echo $out/${qtbase.qtQmlPrefix}"

  '' + lib.optionalString finalAttrs.finalPackage.doCheck ''
    substituteInPlace tests/common/dbus-services/CMakeLists.txt \
      ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.MissionControl5.service"} \
      ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.AccountManager.service"} \
      ${replaceDbusService dconf "ca.desrt.dconf.service"}

    substituteInPlace cmake/modules/GenerateTest.cmake \
      --replace '/usr/lib/dconf' '${lib.getLib dconf}/libexec' \
      --replace '/usr/lib/telepathy' '${lib.getLib telepathy-mission-control}/libexec'
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
    history-service
    libnotify
    libphonenumber
    libpulseaudio
    libusermetrics
    lomiri-url-dispatcher
    protobuf
    (python3.withPackages (ps: with ps; [
      dbus-python
      pygobject3
    ]))
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
    gnome.gnome-keyring
    telepathy-mission-control
    xvfb-run
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # These rely on libphonenumber reformatting inputs to certain results
    # Seem to be broken for a small amount of numbers, maybe libphonenumber version change?
    (lib.cmakeBool "SKIP_QML_TESTS" true)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (lib.concatStringsSep ";" [
      # Exclude tests
      "-E" (lib.strings.escapeShellArg "(${lib.concatStringsSep "|" [
        # Flaky, randomly failing to launch properly & stuck until test timeout
        "^HandlerTest"
        "^OfonoAccountEntryTest"
        "^TelepathyHelperSetupTest"
        "^AuthHandlerTest"
        "^ChatManagerTest"
      ]})")
    ]))
  ];

  env.NIX_CFLAGS_COMPILE = toString ([
    "-I${lib.getDev telepathy-glib}/include/telepathy-1.0" # it's in telepathy-farstream's Requires.private, so it & its dependencies don't get pulled in
    "-I${lib.getDev dbus-glib}/include/dbus-1.0" # telepathy-glib dependency
    "-I${lib.getDev dbus}/include/dbus-1.0" # telepathy-glib dependency
  ]);

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Starts & talks to D-Bus services, breaks with parallelism
  enableParallelChecking = false;

  preCheck = ''
    export QT_QPA_PLATFORM=minimal
    export QT_PLUGIN_PATH=${lib.makeSearchPathOutput "bin" qtbase.qtPluginPrefix [ qtbase qtpim ]}
  '';

  postInstall = ''
    patchShebangs $out/bin/{ofono-setup,phone-gsettings-migration.py}

    # Still missing getprop from libhybris, we don't have it packaged (yet?)
    wrapProgram $out/bin/ofono-setup \
      --prefix PATH : ${lib.makeBinPath [ dbus dconf gettext glib telepathy-mission-control ]}

    # These SystemD services are referenced by the installed D-Bus services, but not part of the installation. Why?
    for service in telephony-service-{approver,indicator}; do
      install -Dm644 ../debian/telephony-service."$service".user.service $out/lib/systemd/user/"$service".service

      # ofono-setup.service would be rovided by ubuntu-touch-session, we don't plan to package it
      substituteInPlace $out/lib/systemd/user/"$service".service \
        --replace '/usr' "$out" \
        --replace 'Requires=ofono-setup.service' "" \
        --replace 'After=ofono-setup.service' "" \

      sed -i $out/lib/systemd/user/"$service".service \
        -e '/ofono-setup.service/d'
    done

    # Parses the call & SMS indicator desktop files & tries to find its own executable in PATH
    wrapProgram $out/bin/telephony-service-indicator \
      --prefix PATH : "$out/bin"
  '';

  passthru = {
    ayatana-indicators = [
      "telephony-service-indicator"
    ];
    tests.vm = nixosTests.ayatana-indicators;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Backend dispatcher service for various mobile phone related operations";
    homepage = "https://gitlab.com/ubports/development/core/telephony-service";
    changelog = "https://gitlab.com/ubports/development/core/telephony-service/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    # Completely broken until https://github.com/NixOS/nixpkgs/pull/314043 is merged
    broken = true;
  };
})
