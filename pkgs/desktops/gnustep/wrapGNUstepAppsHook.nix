{ makeBinaryWrapper, makeSetupHook }:

makeSetupHook {
  name = "wrapGNUstepAppsHook";
  propagatedBuildInputs = [ makeBinaryWrapper ];
} ./wrapGNUstepAppsHook.sh
