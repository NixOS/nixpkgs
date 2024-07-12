{ lib, newScope }:

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    budgie-desktop-view = callPackage ./budgie-desktop-view { };
    budgie-gsettings-overrides = callPackage ./budgie-gsettings-overrides { };
    budgie-screensaver = callPackage ./budgie-screensaver { };
    budgie-session = callPackage ./budgie-session { };
    magpie = callPackage ./magpie { };
  }
)
