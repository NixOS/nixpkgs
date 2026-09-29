{
  lib,
  makeSetupHook,
  gnu-config,
  stdenv,
  runtimeShell,
}:

makeSetupHook {
  name = "update-autotools-gnu-config-scripts-hook";
  substitutions = {
    gnu_config = gnu-config.override {
      runtimeShell =
        if stdenv.buildPlatform == stdenv.hostPlatform then stdenv.shell else runtimeShell;
    };
  };
  meta.license = lib.licenses.mit;
} ../../../build-support/setup-hooks/update-autotools-gnu-config-scripts.sh
