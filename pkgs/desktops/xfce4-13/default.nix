{ lib, makeSetupHook, newScope, gnome3, gst_all_1 }:

let
  inherit (lib) makeScope;
in

makeScope newScope (self: with self; {
  mkXfceDerivation = callPackage ./mkXfceDerivation.nix { };

  automakeAddFlags = makeSetupHook { } ./automakeAddFlags.sh;

  exo = callPackage ./exo { };

  garcon = callPackage ./garcon { };

  gigolo = callPackage ./gigolo { };

  libxfce4util = callPackage ./libxfce4util { };

  libxfce4ui = callPackage ./libxfce4ui { };

  mousepad = callPackage ./mousepad {
    inherit (gnome3) gtksourceview;
  };

  orage = callPackage ./orage { };

  parole = callPackage ./parole {
    inherit (gst_all_1) gst-plugins-bad gst-plugins-base gst-plugins-good;
    gst-plugins-ugly = null;
  };

  ristretto = callPackage ./ristretto { };

  thunar = callPackage ./thunar { };

  thunar-volman = callPackage ./thunar-volman { };

  tumbler = callPackage ./tumbler { };

  xfburn = callPackage ./xfburn { };

  xfconf = callPackage ./xfconf { };

  xfdesktop = callPackage ./xfdesktop { };

  xfce4-appfinder = callPackage ./xfce4-appfinder { };

  xfce4-dev-tools = callPackage ./xfce4-dev-tools {
    mkXfceDerivation = mkXfceDerivation.override {
      xfce4-dev-tools = null;
    };
  };

  xfce4-dict = callPackage ./xfce4-dict { };

  xfce4-mixer = callPackage ./xfce4-mixer { };

  xfce4-notifyd = callPackage ./xfce4-notifyd { };

  xfce4-panel = callPackage ./xfce4-panel { };

  xfce4-power-manager = callPackage ./xfce4-power-manager { };

  xfce4-screenshooter = callPackage ./xfce4-screenshooter {
    inherit (gnome3) libsoup;
  };

  xfce4-taskmanager = callPackage ./xfce4-taskmanager { };

  xfce4-settings = callPackage ./xfce4-settings { };

  xfce4-terminal = callPackage ./xfce4-terminal {
    inherit (gnome3) vte;
  };

  xfce4-volumed-pulse = callPackage ./xfce4-volumed-pulse { };

  xfwm4 = callPackage ./xfwm4 { };
})
