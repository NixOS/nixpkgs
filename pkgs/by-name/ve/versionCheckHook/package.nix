{
  lib,
  makeSetupHook,
  coreutils,
}:

makeSetupHook {
  name = "version-check-hook";
  substitutions = {
    storeDir = builtins.storeDir;
    envCommand = lib.getExe' coreutils "env"; # Cannot call it env, because it isn't an attrset of environment variables!
  };
  meta = {
    description = "Lookup for $version in the output of --help and --version";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
} ./hook.sh
