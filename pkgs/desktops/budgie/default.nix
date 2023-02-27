{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  budgie-screensaver = callPackage ./budgie-screensaver { };
})
