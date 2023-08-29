{ config
, lib
, pkgs
}:

lib.makeScope pkgs.newScope (self: let
  inherit (self) callPackage;
in {
  # Helpers

  mkTDEComponent = import ./make-tde-component.nix {
    inherit lib;
    inherit (pkgs) fetchurl;
  };

  # Sources

  sources = import ./sources.nix;

})
