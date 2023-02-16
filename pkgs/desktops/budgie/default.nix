{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  budgie-control-center = callPackage ./budgie-control-center { };
  budgie-desktop = callPackage ./budgie-desktop { };
  budgie-desktop-view = callPackage ./budgie-desktop-view { };
  budgie-screensaver = callPackage ./budgie-screensaver { };
})
