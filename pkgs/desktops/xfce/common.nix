{ pkgs, newScope, xfce_self }: rec {

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

    # intelligent fetcher for Xfce
    fetchXfce = rec {
      generic = prepend : name : hash :
        let lib = pkgs.lib;
            p = builtins.parseDrvName name;
            versions = lib.splitString "." p.version;
            ver_maj = lib.concatStrings (lib.intersperse "." (lib.take 2 versions));
            name_low = lib.toLower p.name;
        in pkgs.fetchurl {
          url = "mirror://xfce/src/${prepend}/${name_low}/${ver_maj}/${name}.tar.bz2";
          sha256 = hash;
        };
      core = generic "xfce";
      app = generic "apps";
      art = generic "art";
    };
  };

  xfce_common = rec {

    inherit (deps) gvfs; # used by NixOS

    #### CORE

    garcon  = callPackage ./core/garcon.nix { v= "0.2.0";   h= "0v7pkvxcayi86z4f173z5l7w270f3g369sa88z59w0y0p7ns7ph2"; };

    # not used anymore TODO: really? Update to 2.99.2?
    gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { };

    # ToDo: segfaults after some work
    tumbler = callPackage ./core/tumbler.nix  { v= "0.1.27"; h= "0s9qj99b81asmlqa823nzykq8g6p9azcp2niak67y9bp52wv6q2c"; };

    xfce4_power_manager = callPackage ./core/xfce4-power-manager.nix  { v= "1.0.10"; h= "1w120k1sl4s459ijaxkqkba6g1p2sqrf9paljv05wj0wz12bpr40"; };


    #### APPLICATIONS
    #TODO: correct links; more stuff

    xfce4notifyd           = callPackage ./applications/xfce4-notifyd.nix      { v= "0.2.2"; h= "0s4ilc36sl5k5mg5727rmqims1l3dy5pwg6dk93wyjqnqbgnhvmn"; };
    gigolo                 = callPackage ./applications/gigolo.nix             { v= "0.4.1"; h= "1y8p9bbv1a4qgbxl4vn6zbag3gb7gl8qj75cmhgrrw9zrvqbbww2"; };
    xfce4taskmanager       = callPackage ./applications/xfce4-taskmanager.nix  { v= "1.0.0"; h= "1vm9gw7j4ngjlpdhnwdf7ifx6xrrn21011almx2vwidhk2f9zvy0"; };
    mousepad               = callPackage ./applications/mousepad.nix           { v= "0.3.0"; h= "0v84zwhjv2xynvisn5vmp7dbxfj4l4258m82ks7hn3adk437bwhh"; };
    thunar_volman          = callPackage ./core/thunar-volman.nix              { };
    thunar_archive_plugin  = callPackage ./core/thunar-archive-plugin.nix      { };


    #### ART

    xfce4icontheme  = callPackage ./art/xfce4-icon-theme.nix  { v= "4.4.3"; h= "1yk6rx3zr9grm4jwpjvqdkl13pisy7qn1wm5cqzmd2kbsn96cy6l"; };

    #### PANEL PLUGINS

    xfce4_systemload_plugin = callPackage ./panel-plugins/xfce4-systemload-plugin.nix { };
    xfce4_cpufreq_plugin    = callPackage ./panel-plugins/xfce4-cpufreq-plugin.nix    { };
    xfce4_xkb_plugin        = callPackage ./panel-plugins/xfce4-xkb-plugin.nix        { };

  };
}

