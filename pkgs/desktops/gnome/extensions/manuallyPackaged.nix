{ callPackage }:
{
  "arcmenu@arcmenu.com" = callPackage ./arcmenu { };
  "argos@pew.worldwidemann.com" = callPackage ./argos { };
  "EasyScreenCast@iacopodeenosee.gmail.com" = callPackage ./EasyScreenCast { };
  "forge@jmmaranan.com" = callPackage ./forge { };
  "gsconnect@andyholmes.github.io" = callPackage ./gsconnect { };
  "guillotine@fopdoodle.net" = callPackage ./guillotine { };
  "impatience@gfxmonk.net" = callPackage ./impatience { };
  "pop-shell@system76.com" = callPackage ./pop-shell { };
  # hardpixel extensions won't receive updates on extensions.gnome.org:
  # - https://github.com/hardpixel/systemd-manager/issues/19
  # - https://github.com/hardpixel/unite-shell/issues/353
  "systemd-manager@hardpixel.eu" = callPackage ./systemd-manager { };
  "unite@hardpixel.eu" = callPackage ./unite { };
  "valent@andyholmes.ca" = callPackage ./valent { };
}
