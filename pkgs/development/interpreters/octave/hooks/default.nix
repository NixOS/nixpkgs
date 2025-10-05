# Hooks for building Octave packages.
{
  octave,
  lib,
  callPackage,
  makeSetupHook,
}:

{
  writeRequiredOctavePackagesHook = callPackage (
    { }:
    makeSetupHook {
      name = "write-required-octave-packages-hook";
    } ./write-required-octave-packages-hook.sh
  ) { };
}
