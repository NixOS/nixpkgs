# Hooks for building Octave packages.
{
  makeSetupHook,
}:

{
  writeRequiredOctavePackagesHook = makeSetupHook {
    name = "write-required-octave-packages-hook";
  } ./write-required-octave-packages-hook.sh;
}
