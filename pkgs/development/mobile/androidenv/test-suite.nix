{ stdenv, callPackage }:
let
  examples-shell = callPackage ./examples/shell.nix {};
in
stdenv.mkDerivation {
  name = "androidenv-test-suite";

  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  passthru.tests = { } // examples-shell.passthru.tests;

  meta.timeout = 60;
}
