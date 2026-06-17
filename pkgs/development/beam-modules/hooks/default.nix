{ makeSetupHook }:
{
  beamCopySourceHook = makeSetupHook {
    name = "beam-copy-source-hook.sh";
  } ./beam-copy-source-hook.sh;

  beamModuleInstallHook = makeSetupHook {
    name = "beam-module-install-hook.sh";
  } ./beam-module-install-hook.sh;

  mixBuildDirHook = makeSetupHook {
    name = "mix-configure-hook.sh";
  } ./mix-build-dir-hook.sh;

  mixCompileHook = makeSetupHook {
    name = "mix-compile-hook.sh";
  } ./mix-compile-hook.sh;

  mixAppConfigPatchHook = makeSetupHook {
    name = "mix-config-patch-hook.sh";
  } ./mix-app-config-patch-hook.sh;

  rebar3CompileHook = makeSetupHook {
    name = "rebar3-compile-hook.sh";
  } ./rebar3-compile-hook.sh;

  rebarDevendorPatchHook = makeSetupHook {
    name = "rebar-devendor-patch-hook.sh";
  } ./rebar-devendor-patch-hook.sh;
}
