{
  callPackage,
  lib,
  stdenv,
}:
let
  examples-shell = callPackage ./examples/shell.nix { };
  examples-shell-with-emulator = callPackage ./examples/shell-with-emulator.nix { };
  examples-shell-without-emulator = callPackage ./examples/shell-without-emulator.nix { };
  all-tests =
    examples-shell.passthru.tests
    // (examples-shell-with-emulator.passthru.tests // examples-shell-without-emulator.passthru.tests);
in
stdenv.mkDerivation {
  name = "androidenv-test-suite";
  buidInputs = lib.mapAttrsToList (name: value: value) all-tests;

  buildCommand = ''
    touch $out
  '';

  passthru.tests = all-tests;

  meta.timeout = 60;
}
