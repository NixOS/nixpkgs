# Hooks for building Octave packages.
{
  lib,
  makeSetupHook,
}:

{
  writeRequiredOctavePackagesHook = makeSetupHook {
    name = "write-required-octave-packages-hook";
    meta.license = lib.licenses.mit;
  } ./write-required-octave-packages-hook.sh;
}
