{
  lib,
  makeSetupHook,
}:
{
  beamCopySourceHook = makeSetupHook {
    name = "beam-copy-source-hook.sh";
    meta.license = lib.licenses.mit;
  } ./beam-copy-source-hook.sh;

  beamModuleInstallHook = makeSetupHook {
    name = "beam-module-install-hook.sh";
    meta.license = lib.licenses.mit;
  } ./beam-module-install-hook.sh;

  mixBuildDirHook = makeSetupHook {
    name = "mix-configure-hook.sh";
    meta.license = lib.licenses.mit;
  } ./mix-build-dir-hook.sh;

  mixCompileHook = makeSetupHook {
    name = "mix-compile-hook.sh";
    meta.license = lib.licenses.mit;
  } ./mix-compile-hook.sh;

  mixAppConfigPatchHook = makeSetupHook {
    name = "mix-config-patch-hook.sh";
    meta.license = lib.licenses.mit;
  } ./mix-app-config-patch-hook.sh;

  rebar3CompileHook = makeSetupHook {
    name = "rebar3-compile-hook.sh";
    meta.license = lib.licenses.mit;
  } ./rebar3-compile-hook.sh;

  rebarDevendorPatchHook = makeSetupHook {
    name = "rebar-devendor-patch-hook.sh";
    meta.license = lib.licenses.mit;
  } ./rebar-devendor-patch-hook.sh;
}
