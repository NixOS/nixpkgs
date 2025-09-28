{
  callPackage,
  lib,
  stdenv,
  meta,
}:
let
  examples-shell = callPackage ./examples/shell.nix { licenseAccepted = true; };
  examples-shell-with-emulator = callPackage ./examples/shell-with-emulator.nix {
    licenseAccepted = true;
  };
  examples-shell-without-emulator = callPackage ./examples/shell-without-emulator.nix {
    licenseAccepted = true;
  };
  all-tests =
    examples-shell.passthru.tests
    // (examples-shell-with-emulator.passthru.tests // examples-shell-without-emulator.passthru.tests);
in
stdenv.mkDerivation {
  name = "androidenv-test-suite";
  version = lib.substring 0 8 (builtins.hashFile "sha256" ./repo.json);
  buildInputs = lib.mapAttrsToList (name: value: value) all-tests;

  buildCommand = ''
    touch $out
  '';

  passthru.tests = all-tests;

  passthru.updateScript = {
    command = [ ./update.rb ];
    attrPath = "androidenv.test-suite";
    supportedFeatures = [ "commit" ];
  };

  meta = meta // {
    timeout = 60;
  };
}
