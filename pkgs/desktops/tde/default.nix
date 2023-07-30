{ config
, lib
, pkgs
}:

lib.makeScope pkgs.newScope (self: let
  inherit (self) callPackage;
in {
})
