{ makeSetupHook, gnu-config }:
makeSetupHook {
  name = "update-autotools-gnu-config-scripts-hook";
  substitutions = {
    gnu_config = gnu-config;
  };
} ./update-autotools-gnu-config-scripts.sh
