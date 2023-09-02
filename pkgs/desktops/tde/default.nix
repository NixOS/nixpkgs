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

  # Components

  tde-cmake = callPackage ./tde-cmake { };
  tqt3 = callPackage ./tqt3 { };
  tqtinterface = callPackage ./tqtinterface { };

})
