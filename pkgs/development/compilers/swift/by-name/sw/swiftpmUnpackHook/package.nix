{
  lib,
  callPackage,
  jq,
  makeSetupHook,
  swiftpm,
}:

makeSetupHook {
  name = "${lib.getName swiftpm}-unpack-hook-${lib.getVersion swiftpm}";
  substitutions = {
    jq = lib.getExe jq;
  };
  passthru.tests = lib.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./tests;
  };
} ./setup-hook.sh
