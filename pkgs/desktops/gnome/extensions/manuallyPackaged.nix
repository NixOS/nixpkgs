{ callPackage }:
{
  "arcmenu@arcmenu.com" = callPackage ./arcmenu { };
  "argos@pew.worldwidemann.com" = callPackage ./argos { };
  "clock-override@gnomeshell.kryogenix.org" = callPackage ./clock-override { };
  "drop-down-terminal@gs-extensions.zzrough.org" = callPackage ./drop-down-terminal { };
  "EasyScreenCast@iacopodeenosee.gmail.com" = callPackage ./EasyScreenCast { };
  "gsconnect@andyholmes.github.io" = callPackage ./gsconnect { };
  "guillotine@fopdoodle.net" = callPackage ./guillotine { };
  "impatience@gfxmonk.net" = callPackage ./impatience { };
  "no-title-bar@jonaspoehler.de" = callPackage ./no-title-bar { };
  "pidgin@muffinmad" = callPackage ./pidgin-im-integration { };
  "pop-shell@system76.com" = callPackage ./pop-shell { };
  "sound-output-device-chooser@kgshank.net" = callPackage ./sound-output-device-chooser { };
  "systemd-manager@hardpixel.eu" = callPackage ./systemd-manager { };
  "taskwhisperer-extension@infinicode.de" = callPackage ./taskwhisperer { };
  "tilingnome@rliang.github.com" = callPackage ./tilingnome { };
  "TopIcons@phocean.net" = callPackage ./topicons-plus { };
  # Can be removed when https://github.com/hardpixel/unite-shell/issues/353 resolved
  "unite@hardpixel.eu" = callPackage ./unite { };
  "valent@andyholmes.ca" = callPackage ./valent { };
  "window-corner-preview@fabiomereu.it" = callPackage ./window-corner-preview { };
}
