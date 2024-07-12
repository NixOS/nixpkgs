{ lib, newScope }:

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    budgie-session = callPackage ./budgie-session { };
    magpie = callPackage ./magpie { };
  }
)
