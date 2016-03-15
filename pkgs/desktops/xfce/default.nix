{ config, pkgs, newScope }:

let

callPackage = newScope (deps // xfce_self);

deps = { # xfce-global dependency overrides should be here
  inherit (pkgs.gnome) libglade libwnck vte gtksourceview;
  inherit (pkgs.gnome3) dconf;
  inherit (pkgs.perlPackages) URI;
};

xfce_self = rec { # the lines are very long but it seems better than the even-odd line approach

  #### NixOS support

  gvfs = pkgs.gvfs.override { samba = null; }; # samba is a rather heavy dependency
  xinitrc = "${xfce4session}/etc/xdg/xfce4/xinitrc";

  #### CORE                 from "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2"

  exo             = callPackage ./core/exo.nix { };
  garcon          = callPackage ./core/garcon.nix { };
  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { }; # ToDo: when should be used?
  libxfce4ui      = callPackage ./core/libxfce4ui.nix { };
  libxfce4ui_gtk3 = libxfce4ui.override { withGtk3 = true; };
  libxfce4util    = callPackage ./core/libxfce4util.nix { };
  libxfcegui4     = callPackage ./core/libxfcegui4.nix { };
  thunar-build    = callPackage ./core/thunar-build.nix { };
  thunar          = callPackage ./core/thunar.nix { };
  thunarx-2-dev   = thunar-build; # Plugins need only the `thunarx-2` part of the package. Awaiting multiple outputs.
  thunar_volman   = callPackage ./core/thunar-volman.nix { }; # ToDo: probably inside Thunar now
  thunar-archive-plugin 
                  = callPackage ./thunar-plugins/archive { };
  thunar-dropbox-plugin 
                  = callPackage ./thunar-plugins/dropbox { };
  tumbler         = callPackage ./core/tumbler.nix { };
  xfce4panel      = callPackage ./core/xfce4-panel.nix { }; # ToDo: impure plugins from /run/current-system/sw/lib/xfce4
  xfce4panel_gtk3 = xfce4panel.override { withGtk3 = true; };
  xfce4session    = callPackage ./core/xfce4-session.nix { };
  xfce4settings   = callPackage ./core/xfce4-settings.nix { };
  xfce4_power_manager = callPackage ./core/xfce4-power-manager.nix { };
  xfconf          = callPackage ./core/xfconf.nix { };
  xfdesktop       = callPackage ./core/xfdesktop.nix { };
  xfwm4           = callPackage ./core/xfwm4.nix { };

  xfce4_appfinder = callPackage ./core/xfce4-appfinder.nix { };
  xfce4_dev_tools = callPackage ./core/xfce4-dev-tools.nix { }; # only if autotools are needed

  #### APPLICATIONS         from "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2"

  gigolo          = callPackage ./applications/gigolo.nix { };
  mousepad        = callPackage ./applications/mousepad.nix { };
  orage           = callPackage ./applications/orage.nix { };
  parole          = callPackage ./applications/parole.nix { };
  ristretto       = callPackage ./applications/ristretto.nix { };
  terminal        = xfce4terminal; # it has changed its name
  xfce4mixer      = callPackage ./applications/xfce4-mixer.nix {
    pulseaudioSupport = config.pulseaudio or false;
  };
  xfce4notifyd    = callPackage ./applications/xfce4-notifyd.nix { };
  xfce4taskmanager= callPackage ./applications/xfce4-taskmanager.nix { };
  xfce4terminal   = callPackage ./applications/terminal.nix { };
  xfce4screenshooter   = callPackage ./applications/xfce4-screenshooter.nix { };
  xfce4volumed    = let
    gst = callPackage ./applications/xfce4-volumed.nix { };
    pulse = callPackage ./applications/xfce4-volumed-pulse.nix { };
  in if config.pulseaudio or false then pulse else gst;

  #### ART                  from "mirror://xfce/src/art/${p_name}/${ver_maj}/${name}.tar.bz2"

  xfce4icontheme  = callPackage ./art/xfce4-icon-theme.nix { };

  #### PANEL PLUGINS        from "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.{bz2,gz}"

  xfce4_battery_plugin     = callPackage ./panel-plugins/xfce4-battery-plugin.nix     { };
  xfce4_clipman_plugin     = callPackage ./panel-plugins/xfce4-clipman-plugin.nix     { };
  xfce4_cpufreq_plugin     = callPackage ./panel-plugins/xfce4-cpufreq-plugin.nix     { };
  xfce4_cpugraph_plugin    = callPackage ./panel-plugins/xfce4-cpugraph-plugin.nix    { };
  xfce4_datetime_plugin    = callPackage ./panel-plugins/xfce4-datetime-plugin.nix    { };
  xfce4_dict_plugin        = callPackage ./panel-plugins/xfce4-dict-plugin.nix        { };
  xfce4_embed_plugin       = callPackage ./panel-plugins/xfce4-embed-plugin.nix       { };
  xfce4_eyes_plugin        = callPackage ./panel-plugins/xfce4-eyes-plugin.nix        { };
  xfce4_fsguard_plugin     = callPackage ./panel-plugins/xfce4-fsguard-plugin.nix     { };
  xfce4_genmon_plugin      = callPackage ./panel-plugins/xfce4-genmon-plugin.nix      { };
  xfce4_netload_plugin     = callPackage ./panel-plugins/xfce4-netload-plugin.nix     { };
  xfce4_notes_plugin       = callPackage ./panel-plugins/xfce4-notes-plugin.nix       { };
  xfce4_systemload_plugin  = callPackage ./panel-plugins/xfce4-systemload-plugin.nix  { };
  xfce4_verve_plugin       = callPackage ./panel-plugins/xfce4-verve-plugin.nix       { };
  xfce4_xkb_plugin         = callPackage ./panel-plugins/xfce4-xkb-plugin.nix         { };
  xfce4_whiskermenu_plugin = callPackage ./panel-plugins/xfce4-whiskermenu-plugin.nix { };
  xfce4_pulseaudio_plugin  = callPackage ./panel-plugins/xfce4-pulseaudio-plugin.nix  { };

}; # xfce_self

in xfce_self




