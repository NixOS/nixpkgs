{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "version-check-hook";
  substitutions = {
    storeDir = builtins.storeDir;
  };
  meta = {
    description = "Lookup for $version in the output of --help and --version";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
} ./hook.sh
