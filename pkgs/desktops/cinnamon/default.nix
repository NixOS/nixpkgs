{ config, pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  iso-flags-png-320x420 = pkgs.iso-flags.overrideAttrs (p: p // {
    buildPhase = "make png-country-320x240-fancy";
    # installPhase = "mkdir -p $out/share && mv build/png-country-4x2-fancy/res-320x240 $out/share/iso-flags-png-320x420";
    installPhase = "mkdir -p $out/share && mv build/png-country-4x2-fancy/res-320x240 $out/share/iso-flags-png";
  });

  iso-flags-svg = pkgs.iso-flags.overrideAttrs (p: p // {
    buildPhase = "mkdir -p $out/share";
    installPhase = "mv svg $out/share/iso-flags-svg";
  });

  # blueberry -> pkgs/tools/bluetooth/blueberry/default.nix
  bulky = callPackage ./bulky { };
  cinnamon-common = callPackage ./cinnamon-common { };
  cinnamon-control-center = callPackage ./cinnamon-control-center { };
  cinnamon-desktop = callPackage ./cinnamon-desktop { };
  cinnamon-gsettings-overrides = callPackage ./cinnamon-gsettings-overrides { };
  cinnamon-menus = callPackage ./cinnamon-menus { };
  cinnamon-translations = callPackage ./cinnamon-translations { };
  cinnamon-screensaver = callPackage ./cinnamon-screensaver { };
  cinnamon-session = callPackage ./cinnamon-session { };
  cinnamon-settings-daemon = callPackage ./cinnamon-settings-daemon { };
  cjs = callPackage ./cjs { };
  nemo = callPackage ./nemo { };
  mint-artwork = callPackage ./mint-artwork { };
  mint-themes = callPackage ./mint-themes { };
  mint-x-icons = callPackage ./mint-x-icons { };
  mint-y-icons = callPackage ./mint-y-icons { };
  muffin = callPackage ./muffin { };
  pix = callPackage ./pix { };
  xapp = callPackage ./xapp { };
  warpinator = callPackage ./warpinator { };
  xreader = callPackage ./xreader { };
  xviewer = callPackage ./xviewer { };
}) // lib.optionalAttrs config.allowAliases {
  # Aliases need to be outside the scope or they will shadow the attributes from parent scope.
  xapps = pkgs.cinnamon.xapp; # added 2022-07-27
}
