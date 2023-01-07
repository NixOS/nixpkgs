{ lib, pkgs, libsForQt5 }:
let
  packages = self:
  let
    inherit (self) callPackage;
  in {

  };
in
lib.makeScope libsForQt5.newScope packages
