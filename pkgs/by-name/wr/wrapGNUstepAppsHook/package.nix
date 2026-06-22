{
  lib,
  makeBinaryWrapper,
  makeSetupHook,
}:

makeSetupHook {
  name = "wrapGNUstepAppsHook";
  propagatedBuildInputs = [ makeBinaryWrapper ];
  meta.license = lib.licenses.mit;
} ./wrapGNUstepAppsHook.sh
