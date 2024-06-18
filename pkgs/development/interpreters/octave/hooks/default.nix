# Hooks for building Octave packages.
{ octave
, lib
, callPackage
, makeSetupHook
}:

rec {
  writeRequiredOctavePackagesHook = callPackage ({ }:
    makeSetupHook {
      name = "write-required-octave-packages-hook";
    } ./write-required-octave-packages-hook.sh) {};
}
