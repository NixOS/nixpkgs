{
  lib,
  runCommand,
  versitygw,
}:

let
  overridden = versitygw.overrideAttrs (old: {
    pname = "${old.pname}-test-override";
  });
in
assert lib.assertMsg (
  overridden.tests.nixos.drvPath != versitygw.tests.nixos.drvPath
) "The VersityGW NixOS test must use the overridden package";
runCommand "versitygw-test-overrides" { } ''
  touch "$out"
''
