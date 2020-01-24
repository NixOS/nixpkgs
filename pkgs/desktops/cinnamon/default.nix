{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  cinnamon-desktop = callPackage ./cinnamon-desktop { };
  cinnamon-menus = callPackage ./cinnamon-menus { };
  cinnamon-translations = callPackage ./cinnamon-translations { };
  cinnamon-session = callPackage ./cinnamon-session { };
  cinnamon-settings-daemon = callPackage ./cinnamon-settings-daemon { };
  cjs = callPackage ./cjs { };
  nemo = callPackage ./nemo { };
  xapps = callPackage ./xapps { };
})
