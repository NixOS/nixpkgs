{
  lib,
  stdenv,
  systemd-verify-units-hook,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "systemd-verify-units-hook-test";

  nativeInstallCheckInputs = [
    systemd-verify-units-hook
  ];

  dontUnpack = true;
  doInstallCheck = true;

  unitValid = ''
    [Unit]
    Description=Valid Unit

    [Service]
    ExecStart=/bin/sh -c 'exit 0'

    [Install]
    WantedBy=multi-user.target
  '';

  unitWithUnknownKey = ''
    [Unit]
    Description=Invalid Unit

    [Service]
    ExecStart=/bin/sh -c 'exit 0'
    UnknownKey=somevalue

    [Install]
    WantedBy=multi-user.target
  '';

  unitWithUnknownSection = ''
    [Unit]
    Description=Invalid Unit

    [Service]
    ExecStart=/bin/sh -c 'exit 0'

    [UnknownSection]
    SomeKey=somevalue

    [Install]
    WantedBy=multi-user.target
  '';

  unitWithCustomLocation = ''
    [Unit]
    Description=Custom Location Unit

    [Service]
    ExecStart=/bin/sh -c 'exit 0'

    [Install]
    WantedBy=multi-user.target
  '';

  unitToSkip = ''
    broken
  '';

  passAsFile = [
    "unitValid"
    "unitWithUnknownKey"
    "unitWithUnknownSection"
    "unitWithCustomLocation"
    "unitToSkip"
  ];

  systemdVerifyExtraUnits = [ "${placeholder "out"}/opt/custom/systemd/system/*" ];
  systemdVerifySkipUnits = [ "unitToSkip.service" ];
  systemdVerifyAllowUnknownKeys = [ "UnknownKey" ];
  systemdVerifyAllowUnknownSections = [ "UnknownSection" ];

  installPhase = ''
    runHook preInstall

    ${lib.concatMapStringsSep "\n" (u: ''
      install -Dm644 "''$${u}Path" "$out/etc/systemd/system/${u}.service"
    '') finalAttrs.passAsFile}

    install -Dm644 "$unitWithCustomLocationPath" "$out/opt/custom/systemd/system/my-unit.service"

    runHook postInstall
  '';

  postInstallCheck = ''
    echo "test passed"
  '';
})
