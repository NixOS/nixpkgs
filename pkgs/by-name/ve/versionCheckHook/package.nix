{
  lib,
  makeSetupHook,
  bash,
}:

makeSetupHook {
  name = "version-check-hook";
  substitutions = {
    storeDir = builtins.storeDir;
    bash = lib.getExe bash;
  };
  meta = {
    description = "Lookup for $version in the output of --help and --version";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
} ./hook.sh
