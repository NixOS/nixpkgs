{
  backendCC,
  backendStdenv,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  lib,
  pkgs,
  runCommand,
  stdenv,
  stdenvAdapters,
}:
let
  noCC = backendStdenv.override {
    cc = null;
    hasCC = false;
  };
  restored = stdenvAdapters.overrideCC backendStdenv stdenv.cc;
  # This adapter also consumes the selected compiler's wrapper override API.
  hardened = stdenvAdapters.withDefaultHardeningFlags [ ] backendStdenv;
  replaced = import pkgs.path {
    localSystem = "x86_64-linux";
    config = {
      allowUnfree = true;
      cudaCapabilities = [ "8.0" ];
      replaceStdenv =
        { pkgs }:
        let
          cuda = pkgs."cudaPackages_${lib.replaceStrings [ "." ] [ "_" ] cudaMajorMinorVersion}";
        in
        # Force compiler selection while the final stdenv is under construction.
        # A cache owned by that final stage would introduce a construction cycle.
        assert cuda.backendCC.isGNU;
        cuda.backendStdenv;
    };
  };
in
# stdenv adapters consume constructor arguments through override. Wrapping a
# returned stdenv in callPackage would replace that API with package arguments.
assert !noCC.hasCC && noCC.cc == null;
assert restored.cc.drvPath == stdenv.cc.drvPath;
assert builtins.isString hardened.drvPath;
assert backendStdenv.cc.drvPath == (backendCC.__spliced.buildHost or backendCC).drvPath;
assert builtins.isString replaced.stdenvNoCC.drvPath;
assert builtins.isString replaced.cudaPackages.backendStdenv.drvPath;
runCommand "${cudaNamePrefix}-tests-backend-stdenv" { } ''
  touch "$out"
''
