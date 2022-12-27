{ stdenv, callPackage }:
let
  examples-shell = callPackage ./examples/shell.nix {};
  examples-shell-with-emulator = callPackage ./examples/shell-with-emulator.nix {};
in
stdenv.mkDerivation {
  name = "androidenv-test-suite";

  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  passthru.tests = examples-shell.passthru.tests //
    examples-shell-with-emulator.passthru.tests;

  meta.timeout = 60;
}
