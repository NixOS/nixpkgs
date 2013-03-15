{ pkgs, newScope }: let

callPackage = newScope (deps // xfce_self);

deps = rec { # xfce-global dependency overrides should be here
  inherit (pkgs.gnome) libglade libwnck vte gtksourceview;
  inherit (pkgs.perlPackages) URI;

  # The useful bits from ‘gnome-disk-utility’.
  libgdu = callPackage ./support/libgdu.nix { };

  # Gvfs is required by Thunar for the trash feature and for volume
  # mounting.  Should use the one from Gnome, but I don't want to mess
  # with the Gnome packages (or pull in a zillion Gnome dependencies).
  gvfs = callPackage ./support/gvfs.nix { };
};

xfce_self = rec { # the lines are very long but it seems better than the even-odd line approach

  #### NixOS support

  inherit (deps) gvfs;
  xinitrc = "${xfce4session}/etc/xdg/xfce4/xinitrc";

  #### CORE                 from "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2"

  exo             = callPackage ./core/exo.nix { };
  garcon          = callPackage ./core/garcon.nix { };
  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { }; # ToDo: when should be used?
  libxfce4ui      = callPackage ./core/libxfce4ui.nix { };
  libxfce4util    = callPackage ./core/libxfce4util.nix { };
  libxfcegui4     = callPackage ./core/libxfcegui4.nix { };
  thunar          = callPackage ./core/thunar.nix { };
  thunar_volman   = callPackage ./core/thunar-volman.nix { }; # ToDo: probably inside Thunar now
  tumbler         = callPackage ./core/tumbler.nix { }; # ToDo: segfaults after some work
  xfce4panel      = callPackage ./core/xfce4-panel.nix { }; # ToDo: impure plugins from /run/current-system/sw/lib/xfce4
  xfce4session    = callPackage ./core/xfce4-session.nix { };
  xfce4settings   = callPackage ./core/xfce4-settings.nix { };
  xfce4_power_manager = callPackage ./core/xfce4-power-manager.nix { };
  xfceutils       = null; # removed in 4.10
  xfconf          = callPackage ./core/xfconf.nix { };
  xfdesktop       = callPackage ./core/xfdesktop.nix { };
  xfwm4           = callPackage ./core/xfwm4.nix { };

  xfce4_appfinder = callPackage ./core/xfce4-appfinder.nix { };


  #### APPLICATIONS         from "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2"

  gigolo          = callPackage ./applications/gigolo.nix { };
  mousepad        = callPackage ./applications/mousepad.nix { };
  ristretto       = callPackage ./applications/ristretto.nix { };
  terminal        = xfce4terminal; # it has changed its name
  xfce4mixer      = callPackage ./applications/xfce4-mixer.nix { };
  xfce4notifyd    = callPackage ./applications/xfce4-notifyd.nix { };
  xfce4taskmanager= callPackage ./applications/xfce4-taskmanager.nix { };
  xfce4terminal   = callPackage ./applications/terminal.nix { };


  #### ART                  from "mirror://xfce/src/art/${p_name}/${ver_maj}/${name}.tar.bz2"

  xfce4icontheme  = callPackage ./art/xfce4-icon-theme.nix { };


  #### PANEL PLUGINS        from "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2"

  xfce4_systemload_plugin = callPackage ./panel-plugins/xfce4-systemload-plugin.nix { };
  xfce4_cpufreq_plugin    = callPackage ./panel-plugins/xfce4-cpufreq-plugin.nix { };

}; # xfce_self

in xfce_self




