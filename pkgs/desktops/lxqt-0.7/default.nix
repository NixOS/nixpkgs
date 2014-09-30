{ pkgs, newScope }: let

callPackage = newScope (deps // lxqt_self);

deps = rec { # lxqt-global dependency overrides should be here
  inherit (pkgs.gnome) libglade libwnck vte gtksourceview;
  inherit (pkgs.perlPackages) URI;
};

lxqt_self = rec { # the lines are very long but it seems better than the even-odd line approach

  #### NixOS support

  #inherit (pkgs) gvfs;
  #xinitrc = "${lxqtsession}/etc/xdg/lxqt/xinitrc";

  libqtxdg = callPackage ./base/libqtxdg.nix { };
  liblxqt = callPackage ./base/liblxqt.nix { };
  liblxqt-mount = callPackage ./base/liblxqt-mount.nix { };
  lxqt-globalkeys = callPackage ./base/lxqt-globalkeys.nix { };
  lxqt-notificationd = callPackage ./base/lxqt-notificationd.nix { };
  libsysstat = callPackage ./base/libsysstat.nix { };
  menu-cache = callPackage ./base/menu-cache.nix { };

  lxqt-panel = callPackage ./core/lxqt-panel.nix { };
  pcmanfm-qt = callPackage ./core/pcmanfm-qt.nix { };
  lxqt-session = callPackage ./core/lxqt-session.nix { };
  lxqt-runner = callPackage ./core/lxqt-runner.nix { };
  lxqt-qtplugin = callPackage ./core/lxqt-qtplugin.nix { };
  lxqt-policykit = callPackage ./core/lxqt-policykit.nix { };
  lxqt-openssh-askpass = callPackage ./core/lxqt-openssh-askpass.nix { };
  lxqt-powermanagement = callPackage ./core/lxqt-powermanagement.nix { };
  lximage-qt = callPackage ./core/lximage-qt.nix { };
  lxqt-config = callPackage ./core/lxqt-config.nix { };
  lxqt-config-randr = callPackage ./core/lxqt-config-randr.nix { };
  # ...
  compton-conf = callPackage ./core/compton-conf.nix { };
  lxqt-about = callPackage ./core/lxqt-about.nix { };

  lxqt-common = callPackage ./data/lxqt-common.nix { };
  lxmenu-data = callPackage ./data/lxmenu-data.nix { };
}; # lxqt_self

in lxqt_self
