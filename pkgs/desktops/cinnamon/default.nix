{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  cinnamon-desktop = callPackage ./cinnamon-desktop { };
  cjs = callPackage ./cjs { };
  xapps = callPackage ./xapps { };
})
