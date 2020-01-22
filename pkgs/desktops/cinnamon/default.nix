{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  cinnamon-desktop = callPackage ./cinnamon-desktop { };
  cinnamon-menus = callPackage ./cinnamon-menus { };
  cinnamon-translations = callPackage ./cinnamon-translations { };
  cinnamon-settings-daemon = callPackage ./cinnamon-settings-daemon { };
  cjs = callPackage ./cjs { };
  xapps = callPackage ./xapps { };
})
