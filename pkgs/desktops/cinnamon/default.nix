{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  cinnamon-control-center = callPackage ./cinnamon-control-center { };
  cinnamon-desktop = callPackage ./cinnamon-desktop { };
  cinnamon-menus = callPackage ./cinnamon-menus { };
  cinnamon-translations = callPackage ./cinnamon-translations { };
  cinnamon-session = callPackage ./cinnamon-session { };
  cinnamon-settings-daemon = callPackage ./cinnamon-settings-daemon { };
  cjs = callPackage ./cjs { };
  nemo = callPackage ./nemo { };
  mint-themes = callPackage ./mint-themes { };
  mint-y-icons = callPackage ./mint-y-icons { };
  muffin = callPackage ./muffin { };
  xapps = callPackage ./xapps { };
})
