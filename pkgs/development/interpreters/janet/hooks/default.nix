{
  makeSetupHook,
  spork,
}:
{
  bundleShimJpmHook = makeSetupHook {
    name = "janet-bundle-shim-jpm-hook";
    substitutions = { inherit spork; };
  } ./bundle-shim-jpm-hook.sh;

  bundleInstallHook = makeSetupHook {
    name = "janet-bundle-install-hook";
  } ./bundle-install-hook.sh;
}
