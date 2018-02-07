{ pkgs, makeScope, libsForQt5, fetchFromGitHub }:

let
  packages = self: with self; {

    # For compiling information, see:
    # - https://github.com/lxde/lxqt/wiki/Building-from-source

    ### BASE
    libqtxdg = callPackage ./base/libqtxdg { };
    lxqt-build-tools = callPackage ./base/lxqt-build-tools { };
    libsysstat = callPackage ./base/libsysstat { };
    liblxqt = callPackage ./base/liblxqt { };

    ### CORE 1
    libfm-qt = callPackage ./core/libfm-qt { };
    lxqt-about = callPackage ./core/lxqt-about { };
    lxqt-admin = callPackage ./core/lxqt-admin { };
    lxqt-config = callPackage ./core/lxqt-config { };
    lxqt-globalkeys = callPackage ./core/lxqt-globalkeys { };
    lxqt-l10n = callPackage ./core/lxqt-l10n { };
    lxqt-notificationd = callPackage ./core/lxqt-notificationd { };
    lxqt-openssh-askpass = callPackage ./core/lxqt-openssh-askpass { };
    lxqt-policykit = callPackage ./core/lxqt-policykit { };
    lxqt-powermanagement = callPackage ./core/lxqt-powermanagement { };
    lxqt-qtplugin = callPackage ./core/lxqt-qtplugin { };
    lxqt-session = callPackage ./core/lxqt-session { };
    lxqt-sudo = callPackage ./core/lxqt-sudo { };
    lxqt-themes = callPackage ./core/lxqt-themes { };
    pavucontrol-qt = libsForQt5.callPackage ./core/pavucontrol-qt { };
    qtermwidget = callPackage ./core/qtermwidget { };
    # for now keep version 0.7.1 because virt-manager-qt currently does not compile with qtermwidget-0.8.0
    qtermwidget_0_7_1 = callPackage ./core/qtermwidget/0.7.1.nix { };

    ### CORE 2
    lxqt-panel = callPackage ./core/lxqt-panel { };
    lxqt-runner = callPackage ./core/lxqt-runner { };
    pcmanfm-qt = callPackage ./core/pcmanfm-qt { };

    ### OPTIONAL
    qterminal = callPackage ./optional/qterminal { };
    compton-conf = pkgs.qt5.callPackage ./optional/compton-conf { };
    obconf-qt = callPackage ./optional/obconf-qt { };
    lximage-qt = callPackage ./optional/lximage-qt { };
    qps = callPackage ./optional/qps { };
    screengrab = callPackage ./optional/screengrab { };
    qlipper = callPackage ./optional/qlipper { };

    preRequisitePackages = [
      pkgs.gvfs # virtual file systems support for PCManFM-QT
      pkgs.libsForQt5.kwindowsystem # provides some QT5 plugins needed by lxqt-panel
      pkgs.libsForQt5.libkscreen # provides plugins for screen management software
      pkgs.libfm
      pkgs.libfm-extra
      pkgs.lxmenu-data
      pkgs.menu-cache
      pkgs.openbox # default window manager
      pkgs.qt5.qtsvg # provides QT5 plugins for svg icons
    ];

    corePackages = [
      ### BASE
      libqtxdg
      libsysstat
      liblxqt

      ### CORE 1
      libfm-qt
      lxqt-about
      lxqt-admin
      lxqt-config
      lxqt-globalkeys
      lxqt-l10n
      lxqt-notificationd
      lxqt-openssh-askpass
      lxqt-policykit
      lxqt-powermanagement
      lxqt-qtplugin
      lxqt-session
      lxqt-sudo
      lxqt-themes
      pavucontrol-qt

      ### CORE 2
      lxqt-panel
      lxqt-runner
      pcmanfm-qt
    ];

    optionalPackages = [
      ### LXQt project
      qterminal
      compton-conf
      obconf-qt
      lximage-qt

      ### QtDesktop project
      qps
      screengrab

      ### Qlipper
      qlipper

      ### Default icon theme
      pkgs.oxygen-icons5

      ### Screen saver
      pkgs.xscreensaver
    ];

  };

in makeScope libsForQt5.newScope packages
