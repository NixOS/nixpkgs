{
  lib,
  jq,
  makeSetupHook,
  swiftpm,
}:

makeSetupHook {
  name = "${lib.getName swiftpm}-unpack-hook-${lib.getVersion swiftpm}";
  substitutions = {
    jq = lib.getExe jq;
  };
} ./setup-hook.sh
