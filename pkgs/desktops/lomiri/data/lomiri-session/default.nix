{ stdenvNoCC
, lib
, fetchFromGitLab
, fetchpatch
, fetchpatch2
, gitUpdater
, nixosTests
, bash
, cmake
, dbus
, deviceinfo
, inotify-tools
, lomiri
, makeWrapper
, pkg-config
, runtimeShell
, systemd
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-session";
  version = "0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-session";
    rev = finalAttrs.version;
    hash = "sha256-1ZpAn1tFtlXIfeejG0TnrJBRjf3tyz7CD+riWo+sd0s=";
  };

  patches = [
    # Properly gate of UBtouch-specific code
    # Otherwise session won't launch, errors out on a removed Mir setting
    # Remove when version > 0.2
    (fetchpatch {
      name = "0001-lomiri-session-Properly-differentiate-between-Ubuntu-Touch-and-Lomiri-Desktop-session.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/780c19d8b4f18ce24ceb64b8abfae70018579dce.patch";
      hash = "sha256-eFiagFEpH43WpVGA6xkI1IiQ99HHizonhXYg1wYAhwU=";
    })

    # Export Lomiri-prefixed stop envvar
    # Remove when version > 0.2
    (fetchpatch {
      name = "0002-lomiri-session-Use-LOMIRI_MIR_EMITS_SIGSTOP.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/452e38b489b5893aac3481410d708f4397b1fa1c.patch";
      hash = "sha256-w/kifBLfDm8+CBliVjm4o8JtjaOByHf97XyPhVk6Gho=";
    })

    # Removes broken first-time wizard check
    # Remove when version > 0.2
    (fetchpatch {
      name = "0003-lomiri-session-Drop-old-wizard-has-run-check.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/c16ae87d8848f9909850072f7728c03c894b1a47.patch";
      hash = "sha256-AIwgztFOGwG2zUsaUen/Z3Mes9m7VgbvNKWp/qYp4g4=";
    })

    # Fix quoting on ps check
    # Remove when version > 0.2
    (fetchpatch {
      name = "0004-lomiri-session-Put-evaluation-of-ps-call-in-quotes.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/2d7368eae99f07200c814c840636206b9eaa485d.patch";
      hash = "sha256-6LqurJqi/I+Qw64hWTrvA8uA/EIRZbcS6TRRXK+9s1s=";
    })

    # Check for Xwayland presense to determine X11 support
    # Remove when version > 0.2
    (fetchpatch {
      name = "0005-lomiri-session-Check-for-Xwayland-presence.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/707e43d3b1a6200535b7682e63817265a8e4ee7e.patch";
      hash = "sha256-sI00P31QVF7ZKdwNep2r+0MetNGg/bbrd2YfEzZPLFI=";
    })

    # Fix systemd service startup things, drop upstart hacks
    # Remove when https://gitlab.com/ubports/development/core/lomiri-session/-/merge_requests/13 merged & in release
    (fetchpatch {
      name = "0100-lomiri-session-Drop-Before-Wants-for-App-Indicator-targets.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/ccebdc1c47d7411a9cf4ad2e529471fb0403433a.patch";
      hash = "sha256-vGFvcCjbwcuLrAUIsL5y/QmoOR5i0560LNv01ZT9OOg=";
    })
    (fetchpatch {
      name = "0101-lomiri-session-Start-lal-application-end.target-on-stop-restart.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/9a945b09feff0c1d2b3203caaf3cec5230481e80.patch";
      hash = "sha256-1vD+I5YDEh2wF7UDn6ZxPTBRrdUvwWVXt5x5QdkIAkY=";
    })
    (fetchpatch {
      name = "0102-lomiri-session-Drop-manual-Xwayland-start-logic.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/6aee0d6cfd76ab1904876f4166621f9f6d833056.patch";
      hash = "sha256-iW/Ko+Xm2ZuJuNE7ATeuMTSHby0fXD+D5nWjX6LLLwU=";
    })
    (fetchpatch {
      name = "0103-lomiri-session-Set-SyslogIdentifier.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/09d378728685411a04333040279cdaef487dedc8.patch";
      hash = "sha256-minJSxrn2d0+FBlf7bdN3ddSvsn6YWdeH6ZuCW7qbII=";
    })
    (fetchpatch {
      name = "0104-lomiri-session-Use-LOMIRI_AS_SYSTEMD_UNIT-to-launch-session.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/9bd2552c2638c139a0abff527fda99f2ef94cc42.patch";
      hash = "sha256-7ipsGrQRJ98uVSRp2e0U4q3iTuyeUalqZIohbxXpT9k=";
    })
    (fetchpatch {
      name = "0105-lomiri-session-Allow-sd_notify-calls-for-NOTIFY_SOCKET.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/2157bfc472f2d35e7c81002a924a1f6aa85f7395.patch";
      hash = "sha256-qtArOG4gysFWGnXbz3KpXEppaZ1PGDQKEGqnJvU6/RE=";
    })
    (fetchpatch {
      name = "0106-lomiri-session-Change-envvar-for-1-time-binary.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/0cd1dbd30f3d5c6e50bce79146e8511e0ee56153.patch";
      hash = "sha256-b8/Mrs36JPJE6l6/Dc/PN+zNV8Oq37HOFx+zMQvWPBY=";
    })
    (fetchpatch {
      name = "0107-lomiri-session-Drag-lomiri-process-under-umbrella-of-wrapper-script.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/d8212b1862924eb283fd1ee7ea390a144d5ee97e.patch";
      hash = "sha256-UJzV0pYEBBrXSpYxdFoBoMRzPeIQtvtPzDW2/Ljz+uI=";
    })
    (fetchpatch {
      name = "0108-lomiri-session-Dont-hide-exit-code-from-systemd.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/9ac78d736caa891a4923be8d040fe8224e335215.patch";
      hash = "sha256-yPg1K0IfaGYKqg9536i9AFCLTcAENlsJNdHjrElSeZ4=";
    })

    # Don't require a C & C++ compiler, nothing to compile
    # Remove when https://gitlab.com/ubports/development/core/lomiri-session/-/merge_requests/14 merged & in release
    (fetchpatch {
      name = "0200-lomiri-session-Dont-require-a-compiler.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/6915a5678e09e5dbcb26d29a8e5585d032a19186.patch";
      hash = "sha256-2SWiOLDLsdTjRHaJcnZe/WKcFMFmHtpZsuj7bQCtB4A=";
    })

    # Use GNUInstallDirs for install locations, find_program() for locations of used binaries
    # fetchpatch2 due to renames, need to resolve merge conflict manually in postPatch
    # Remove when https://gitlab.com/ubports/development/core/lomiri-session/-/merge_requests/15 merged & in release
    (fetchpatch2 {
      name = "0201-lomiri-session-Hardcode-less-locations.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-session/-/commit/d5b93ecaf08ba776a79c69e8a9dd05d0b6181947.patch";
      excludes = [ "systemd/lomiri.service" ];
      hash = "sha256-BICb6ZwU/sUBzmM4udsOndIgw1A03I/UEG000YvMZ9Y=";
    })

    ./1001-Unset-QT_QPA_PLATFORMTHEME.patch
  ];

  postPatch = ''
    # Resolving merge conflict
    mv systemd/lomiri.service{,.in}
    substituteInPlace systemd/lomiri.service.in \
      --replace-fail '/usr/bin/lomiri-session' '@CMAKE_INSTALL_FULL_BINDIR@/lomiri-session' \
      --replace-fail '/usr/bin/dbus-update-activation-environment' '@DUAE_BIN@'

    substituteInPlace lomiri-session \
      --replace-fail '/usr/libexec/Xwayland.lomiri' '${lib.getBin lomiri}/libexec/Xwayland.lomiri'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    bash
    deviceinfo
    dbus
    inotify-tools
    lomiri
    systemd
  ];

  cmakeFlags = [
    # Requires lomiri-system-compositor -> not ported to Mir 2.x yet
    (lib.cmakeBool "ENABLE_TOUCH_SESSION" false)
  ];

  postInstall = ''
    patchShebangs $out/bin/lomiri-session
    wrapProgram $out/bin/lomiri-session \
      --prefix PATH : ${lib.makeBinPath [ deviceinfo inotify-tools lomiri ]}
  '';

  passthru = {
    providedSessions = [
      "lomiri"
      # not packaged/working yet
      # "lomiri-touch"
    ];
    tests.lomiri = nixosTests.lomiri;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Integrates Lomiri desktop/touch sessions into display / session managers";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-session";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-session/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    mainProgram = "lomiri-session";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
