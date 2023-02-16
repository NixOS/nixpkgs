{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  budgie-desktop = callPackage ./budgie-desktop { };
  budgie-screensaver = callPackage ./budgie-screensaver { };
})
