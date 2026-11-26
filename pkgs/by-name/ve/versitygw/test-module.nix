{
  lib,
  nixos,
  runCommand,
}:

let
  evaluate =
    extra:
    (nixos {
      imports = [ extra ];
      system.stateVersion = lib.trivial.release;
    }).config;
  disabled = evaluate { };
  service = {
    enable = true;
    rootDirectory = "/srv/versitygw";
    environmentFile = "/run/secrets/versitygw.env";
  };
  valid = evaluate {
    services.versitygw = service // {
      settings = {
        VGW_QUIET = true;
        VGW_MAX_CONNECTIONS = 100;
        VGW_UNUSED = null;
      };
    };
  };
  unusualPath = evaluate {
    services.versitygw = service // {
      rootDirectory = "/srv/s3-%m's data";
    };
  };
  failures =
    settings:
    lib.filter (assertion: !assertion.assertion && lib.hasPrefix "services.versitygw" assertion.message)
      (evaluate {
        services.versitygw = service // {
          inherit settings;
        };
      }).assertions;
in
assert !(disabled.systemd.services ? versitygw);
assert !(disabled.users.users ? versitygw);
assert valid.systemd.services.versitygw.environment.VGW_QUIET == "true";
assert valid.systemd.services.versitygw.environment.VGW_MAX_CONNECTIONS == "100";
assert !(valid.systemd.services.versitygw.environment ? VGW_UNUSED);
assert valid.networking.firewall.allowedTCPPorts == [ ];
assert lib.any (
  rule: rule == ''d "/srv/s3-%%m's data" 0750 versitygw versitygw - -''
) unusualPath.systemd.tmpfiles.rules;
assert failures { } == [ ];
assert lib.all
  (
    key:
    lib.assertMsg (
      lib.length (failures {
        ${key} = "fixture";
      }) == 1
    ) "The VersityGW module must reject ${key} in settings"
  )
  [
    "VGW_IAM_DIR"
    "ROOT_ACCESS_KEY"
    "ROOT_ACCESS_KEY_ID"
    "ROOT_SECRET_KEY"
    "ROOT_SECRET_ACCESS_KEY"
  ];
runCommand "versitygw-test-module" { } ''
  touch "$out"
''
