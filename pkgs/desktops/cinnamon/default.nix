{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  cinnamon-desktop = callPackage ./cinnamon-desktop { };
  cinnamon-menus = callPackage ./cinnamon-menus { };
  cjs = callPackage ./cjs { };
  xapps = callPackage ./xapps { };
})
