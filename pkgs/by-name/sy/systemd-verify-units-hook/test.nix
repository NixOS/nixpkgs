{
  lib,
  stdenv,
  systemd-verify-units-hook,
  structuredAttrs ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "systemd-verify-units-hook-test";

  __structuredAttrs = structuredAttrs;

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

  unitInPathWithSpace = ''
    [Unit]
    Description=Unit in a path with a space

    [Service]
    ExecStart=/bin/sh -c 'exit 0'

    [Install]
    WantedBy=multi-user.target
  '';

  systemdVerifyExtraUnits = [
    "${placeholder "out"}/opt/custom/systemd/system/*"
    "${placeholder "out"}/opt/custom location/systemd/system/*"
  ];
  systemdVerifySkipUnits = [ "unitToSkip.service" ];
  systemdVerifyAllowUnknownKeys = [ "UnknownKey" ];
  systemdVerifyAllowUnknownSections = [ "UnknownSection" ];

  installPhase =
    let
      defaultInstallUnits = [
        "unitValid"
        "unitWithUnknownKey"
        "unitWithUnknownSection"
        "unitWithCustomLocation"
        "unitToSkip"
        "unitInPathWithSpace"
      ];
    in
    ''
      runHook preInstall

      ${lib.concatMapStringsSep "\n" (u: ''
        install -Dm644 <(printf '%s' "''${${u}}") "$out/etc/systemd/system/${u}.service"
      '') defaultInstallUnits}

      install -Dm644 <(printf '%s' "''${unitWithCustomLocation}") "$out/opt/custom/systemd/system/my-unit.service"
      install -Dm644 <(printf '%s' "''${unitInPathWithSpace}") "$out/opt/custom location/systemd/system/spaced-unit.service"

      runHook postInstall
    '';

  postInstallCheck = ''
    echo "test passed"
  '';
})
