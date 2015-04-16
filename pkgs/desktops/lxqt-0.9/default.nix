{ pkgs, newScope }: let

callPackage = newScope (deps // lxqt_self);

deps = rec { # lxqt-global dependency overrides should be here
#  inherit (pkgs.gnome) libglade libwnck vte gtksourceview;
#  inherit (pkgs.perlPackages) URI;
};

lxqt_self = rec {

  #### NixOS support

  inherit (pkgs) gvfs;
  #xinitrc = "${lxqtsession}/etc/xdg/lxqt/xinitrc";

  # Inputs for callPacakage arguments
  kwindowsystem = pkgs.kde5.kwindowsystem;
  kguiaddons = pkgs.kde5.kguiaddons;
  standardPatch = ''
    for file in $(find . -name CMakeLists.txt); do
      substituteInPlace $file \
        --replace DESTINATION\ \$\{LXQT_ETC_XDG_DIR} 'DESTINATION etc/xdg' \
        --replace DESTINATION\ \$\{LXQT_SHARE_DIR} 'DESTINATION share/lxqt'
    done
  '';

  # For compiling information, see:
  # - http://wiki.lxde.org/en/Build_LXDE-Qt_From_Source
  # - the lxde project on github

  # packages are listed here in the same order as they are
  # compiled by the build_all.sh script in the lxde-qt repository.

  # first the autotools packages
  lxqt-libfm-extras = callPackage ./base/libfm-extras.nix { };
  menu-cache = callPackage ./base/menu-cache.nix { };
  lxmenu-data = callPackage ./data/lxmenu-data.nix { };
  lxqt-libfm = callPackage ./base/libfm.nix { };

  # now the cmake packages

  libqtxdg = callPackage ./base/libqtxdg.nix { };
  liblxqt = callPackage ./base/liblxqt.nix { };
  liblxqt-mount = callPackage ./base/liblxqt-mount.nix { };
  libsysstat = callPackage ./base/libsysstat.nix { };

  lxqt-session = callPackage ./core/lxqt-session.nix { };
  lxqt-qtplugin = callPackage ./core/lxqt-qtplugin.nix { };
  lxqt-globalkeys = callPackage ./core/lxqt-globalkeys.nix { };
  lxqt-notificationd = callPackage ./core/lxqt-notificationd.nix { };
  lxqt-about = callPackage ./core/lxqt-about.nix { };
  lxqt-common = callPackage ./data/lxqt-common.nix { };
  lxqt-config = callPackage ./core/lxqt-config.nix { };

  # requires liboobs-1
  #lxqt-admin = callPackage ./core/lxqt-admin.nix { };

  lxqt-openssh-askpass = callPackage ./core/lxqt-openssh-askpass.nix { };
  lxqt-panel = callPackage ./core/lxqt-panel.nix { };
  lxqt-polkit_qt_1 = callPackage ./polkit-qt-1/default.nix { };
  lxqt-policykit = callPackage ./core/lxqt-policykit.nix { };
  lxqt-powermanagement = callPackage ./core/lxqt-powermanagement.nix { };
  lxqt-runner = callPackage ./core/lxqt-runner.nix { };
  lxqt-pcmanfm-qt = callPackage ./core/pcmanfm-qt.nix { };
  lximage-qt = callPackage ./core/lximage-qt.nix { };

  compton-conf = callPackage ./core/compton-conf.nix { };
  #obconf-qt = callPackage ./core/obconf-qt.nix { };

# TODO:
# - [x] remove -DUSE_QT_5=ON where it's not needed
# - [x] write a script to patch CMakeLists.txt for various paths
# - [x] need to fix Qt's translation path, so translations are stored in the correct place in /nix/store but read from /run/current-system/sw/
# - [ ] need to do something with Qt's plugin path, see http://doc.qt.io/qt-5/deployment-plugins.html
# - [ ] lxqt-common: figure out what to do with the xsession files
# - [ ] test whether `-DLIB_SUFFIX` can be removed from everywhere
# - [ ] install lxqt.desktop in `desktops` package somehow (see desktops/xfce.desktop)
# - [ ] install lxqt.desktop from lxqt-common/xsession to $out/share/xsessions (see xfce4-session/share/xsessions/xfce.desktop)
# - [ ] add maintainers metadata
};

in lxqt_self
