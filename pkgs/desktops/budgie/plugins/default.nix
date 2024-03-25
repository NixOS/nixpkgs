{ callPackage }:

let
  budgieExtras = callPackage ./budgie-extras { };
in

{
  budgie-analogue-clock-applet = callPackage ./budgie-analogue-clock-applet { };
  budgie-media-player-applet = callPackage ./budgie-media-player-applet { };
  budgie-user-indicator-redux = callPackage ./budgie-user-indicator-redux { };
} // budgieExtras
