{ pkgs, makeScope, libsForQt5 }:

let
  packages = self: with self; {

    # For compiling information, see:
    # - https://github.com/lxqt/lxqt/wiki/Building-from-source

    ### BASE
    libqtxdg = callPackage ./libqtxdg { };
    lxqt-build-tools = callPackage ./lxqt-build-tools { };
    libsysstat = callPackage ./libsysstat { };
    liblxqt = callPackage ./liblxqt { };

    ### CORE 1
    libfm-qt = callPackage ./libfm-qt { };
    lxqt-about = callPackage ./lxqt-about { };
    lxqt-admin = callPackage ./lxqt-admin { };
    lxqt-config = callPackage ./lxqt-config { };
    lxqt-globalkeys = callPackage ./lxqt-globalkeys { };
    lxqt-notificationd = callPackage ./lxqt-notificationd { };
    lxqt-openssh-askpass = callPackage ./lxqt-openssh-askpass { };
    lxqt-policykit = callPackage ./lxqt-policykit { };
    lxqt-powermanagement = callPackage ./lxqt-powermanagement { };
    lxqt-qtplugin = callPackage ./lxqt-qtplugin { };
    lxqt-session = callPackage ./lxqt-session { };
    lxqt-sudo = callPackage ./lxqt-sudo { };
    lxqt-themes = callPackage ./lxqt-themes { };
    pavucontrol-qt = libsForQt5.callPackage ./pavucontrol-qt { };
    qtermwidget = callPackage ./qtermwidget { };

    ### CORE 2
    lxqt-panel = callPackage ./lxqt-panel { };
    lxqt-runner = callPackage ./lxqt-runner { };
    pcmanfm-qt = callPackage ./pcmanfm-qt { };

    ### OPTIONAL
    qterminal = callPackage ./qterminal { };
    compton-conf = pkgs.qt5.callPackage ./compton-conf { };
    obconf-qt = callPackage ./obconf-qt { };
    lximage-qt = callPackage ./lximage-qt { };
    qps = callPackage ./qps { };
    screengrab = callPackage ./screengrab { };
    qlipper = callPackage ./qlipper { };

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
