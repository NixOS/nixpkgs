{ lib, debug, wrapQtAppsHook }:

mkDerivation:
finalAttrs: (mkDerivation finalAttrs).overrideAttrs(previousAttrs: {
  nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [ wrapQtAppsHook ];
})
