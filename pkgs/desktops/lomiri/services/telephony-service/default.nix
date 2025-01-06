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
      name = "0001-lomiri-telephony-service-CMakeLists-Make-tests-optional.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/9a8297bcf9b34d77ffdae3dfe4ad2636022976fb.patch";
      hash = "sha256-Za4ZGKnw9iz2RP1LzLhKrEJ1vLUufWk8J07LmWDW40E=";
    })

    # Remove when version > 0.5.3
    (fetchpatch {
      name = "0002-lomiri-telephony-service-Fix-gettext-funcs-in-wrong-namespace.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/18e0ba8e025b097eef1217d97d98ef4a4940fe84.patch";
      hash = "sha256-vOIy+B/OQeccsVn4pXsnr8LYyEapqbebW1I6dBg5u2c=";
    })

    # Remove when version > 0.5.3
    (fetchpatch {
      name = "0003-lomiri-telephony-service-Handle-renamed-history-service.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/3a387670ed13041db069068292b1f41229e79583.patch";
      hash = "sha256-b7gxzr6Mmtogclq3hR7a/zl+816H2wmJqv3oHjUJggw=";
    })

    # Remove when version > 0.5.3
    # Patched to be compatible with pre-rename code
    (runCommand "0004-lomiri-telephony-service-Fix-NotificationInterface-regeneration-backported.patch"
      {
        src = fetchpatch {
          name = "0004-lomiri-telephony-service-Fix-NotificationInterface-regeneration.patch";
          url = "https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/commit/9533ce1a9495e5c11e9b78fc0166e903e19519b4.patch";
          hash = "sha256-3rsZ08bz2CxKpcwYWCCd6f7gJ22v9jl7Lg7JPnWz50A=";
        };
      }
      ''
        cp $src $out
        substituteInPlace $out \
          --replace-fail 'lomiritelephony' 'telephony'
      ''
    )
  ];

  postPatch =
    ''
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
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Flaky, randomly failing to launch properly & stuck until test timeout
            # https://gitlab.com/ubports/development/core/lomiri-telephony-service/-/issues/70
            "^HandlerTest"
            "^OfonoAccountEntryTest"
            "^TelepathyHelperSetupTest"
            "^AuthHandlerTest"
            "^ChatManagerTest"
            "^AccountEntryTest"
            "^AccountEntryFactoryTest"
            "^PresenceRequestTest"
            "^CallEntryTest"
          ]
        })")
      ]
    ))
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
    for service in telephony-service-{approver,indicator}; do
      install -Dm644 ../debian/telephony-service."$service".user.service $out/lib/systemd/user/"$service".service

      # ofono-setup.service would be provided by ubuntu-touch-session, we don't plan to package it
      # Doesn't make sense to provide on non-Lomiri
      substituteInPlace $out/lib/systemd/user/"$service".service \
        --replace-fail '/usr' "$out" \
        --replace-warn 'Requires=ofono-setup.service' "" \
        --replace-warn 'After=ofono-setup.service' "" \
        --replace-warn 'WantedBy=ayatana-indicators.target' 'WantedBy=lomiri-indicators.target'
    done

    # Parses the call & SMS indicator desktop files & tries to find its own executable in PATH
    wrapProgram $out/bin/telephony-service-indicator \
      --prefix PATH : "$out/bin"
  '';

  passthru = {
    ayatana-indicators = {
      telephony-service-indicator = [ "lomiri" ];
    };
    tests.vm = nixosTests.ayatana-indicators;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Backend dispatcher service for various mobile phone related operations";
    homepage = "https://gitlab.com/ubports/development/core/telephony-service";
    changelog = "https://gitlab.com/ubports/development/core/telephony-service/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
