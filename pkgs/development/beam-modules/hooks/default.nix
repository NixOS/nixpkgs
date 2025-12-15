{
  makeSetupHook,
}:
{
  mixConfigureHook = makeSetupHook {
    name = "mix-configure-hook.sh";
  } ./mix-configure-hook.sh;
}
