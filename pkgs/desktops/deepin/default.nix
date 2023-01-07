{ lib, pkgs, libsForQt5 }:
let
  packages = self:
  let
    inherit (self) callPackage;
  in {
    #### LIBRARIES
    dtkcommon = callPackage ./library/dtkcommon { };
    dtkcore = callPackage ./library/dtkcore { };
    dtkgui = callPackage ./library/dtkgui { };

  };
in
lib.makeScope libsForQt5.newScope packages
