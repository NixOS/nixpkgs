{
  callPackage,
  lib,
  recurseIntoAttrs,
}:
let
  flavors = lib.importJSON ./flavors.json;

  flavorPackages = lib.genAttrs flavors (
    flavor:
    callPackage ./generic.nix {
      inherit flavor;
      flavors = flavorPackages;
    }
  );
in
# No need to build all the different flavors on hydra.
# custom flavors can be built via:
#   tasmota.flavors.{flavor}
flavorPackages.tasmota
