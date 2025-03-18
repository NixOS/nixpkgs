{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "version-check-hook";
  meta = {
    description = "Lookup for $version in the output of --help and --version";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
} ./hook.sh
