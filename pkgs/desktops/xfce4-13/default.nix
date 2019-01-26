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

  mousepad = callPackage ./mousepad { };

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

  xfce4-battery-plugin = callPackage ./xfce4-battery-plugin { };

  xfce4-cpufreq-plugin = callPackage ./xfce4-cpufreq-plugin { };

  xfce4-clipman-plugin = callPackage ./xfce4-clipman-plugin { };

  xfce4-dev-tools = callPackage ./xfce4-dev-tools {
    mkXfceDerivation = mkXfceDerivation.override {
      xfce4-dev-tools = null;
    };
  };

  xfce4-dict = callPackage ./xfce4-dict { };

  xfce4-mixer = callPackage ./xfce4-mixer { };

  xfce4-netload-plugin = callPackage ./xfce4-netload-plugin { };

  xfce4-notifyd = callPackage ./xfce4-notifyd { };

  xfce4-panel = callPackage ./xfce4-panel { };

  xfce4-power-manager = callPackage ./xfce4-power-manager { };

  xfce4-pulseaudio-plugin = callPackage ./xfce4-pulseaudio-plugin { };

  xfce4-screenshooter = callPackage ./xfce4-screenshooter {
    inherit (gnome3) libsoup;
  };

  xfce4-session = callPackage ./xfce4-session { };
  xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  xfce4-settings = callPackage ./xfce4-settings { };

  xfce4-taskmanager = callPackage ./xfce4-taskmanager { };

  xfce4-terminal = callPackage ./xfce4-terminal { };

  xfce4-volumed-pulse = callPackage ./xfce4-volumed-pulse { };

  xfce4-whiskermenu-plugin = callPackage ./xfce4-whiskermenu-plugin { };

  xfce4-xkb-plugin = callPackage ./xfce4-xkb-plugin { };

  xfwm4 = callPackage ./xfwm4 { };

  ## COMMON PARTS WITH XFCE 4.12

  gtk-xfce-engine = callPackage ../xfce/core/gtk-xfce-engine.nix { withGtk3 = false; };

  xfce4-icon-theme = callPackage ../xfce/art/xfce4-icon-theme.nix { };

  xfwm4-themes = callPackage ../xfce/art/xfwm4-themes.nix { };

  xfce4-embed-plugin = callPackage ../xfce/panel-plugins/xfce4-embed-plugin.nix { };

  xfce4-hardware-monitor-plugin = callPackage ../xfce/panel-plugins/xfce4-hardware-monitor-plugin.nix { };

  ## THIRD PARTY PLIGINS

  xfce4-dockbarx-plugin = callPackage ../xfce/panel-plugins/xfce4-dockbarx-plugin.nix { };

  xfce4-namebar-plugin = callPackage ../xfce/panel-plugins/xfce4-namebar-plugin.nix { };

  xfce4-windowck-plugin = callPackage ../xfce/panel-plugins/xfce4-windowck-plugin.nix { };
})
