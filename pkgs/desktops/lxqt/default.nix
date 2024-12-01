{ pkgs, makeScope, kdePackages }:

let
  packages = self: with self; {

    # For compiling information, see:
    # - https://github.com/lxqt/lxqt/wiki/Building-from-source

    ### BASE
    libqtxdg = callPackage ./libqtxdg {};
    lxqt-build-tools = callPackage ./lxqt-build-tools {};
    libsysstat = callPackage ./libsysstat {};
    liblxqt = callPackage ./liblxqt {};
    qtxdg-tools = callPackage ./qtxdg-tools {};
    libdbusmenu-lxqt = callPackage ./libdbusmenu-lxqt {};

    ### CORE 1
    libfm-qt = callPackage ./libfm-qt {};
    lxqt-about = callPackage ./lxqt-about {};
    lxqt-admin = callPackage ./lxqt-admin {};
    lxqt-config = callPackage ./lxqt-config {};
    lxqt-globalkeys = callPackage ./lxqt-globalkeys {};
    lxqt-menu-data = callPackage ./lxqt-menu-data {};
    lxqt-notificationd = callPackage ./lxqt-notificationd {};
    lxqt-openssh-askpass = callPackage ./lxqt-openssh-askpass {};
    lxqt-policykit = callPackage ./lxqt-policykit {};
    lxqt-powermanagement = callPackage ./lxqt-powermanagement {};
    lxqt-qtplugin = callPackage ./lxqt-qtplugin {};
    lxqt-session = callPackage ./lxqt-session {};
    lxqt-sudo = callPackage ./lxqt-sudo {};
    lxqt-themes = callPackage ./lxqt-themes {};
    lxqt-wayland-session = callPackage ./lxqt-wayland-session {};
    pavucontrol-qt = callPackage ./pavucontrol-qt {};
    qtermwidget = callPackage ./qtermwidget {};

    ### CORE 2
    lxqt-panel = callPackage ./lxqt-panel {};
    lxqt-runner = callPackage ./lxqt-runner {};
    pcmanfm-qt = callPackage ./pcmanfm-qt {};

    ### OPTIONAL
    qterminal = callPackage ./qterminal {};
    compton-conf = callPackage ./compton-conf {
      lxqt-build-tools = lxqt-build-tools_0_13;
      inherit (pkgs.libsForQt5) qtbase qttools qtx11extras;
    };
    obconf-qt = callPackage ./obconf-qt {};
    lximage-qt = callPackage ./lximage-qt {};
    qps = callPackage ./qps {};
    screengrab = callPackage ./screengrab {};
    qlipper = callPackage ./qlipper {
      inherit (pkgs.libsForQt5) qtbase qttools;
    };
    lxqt-archiver = callPackage ./lxqt-archiver {};
    xdg-desktop-portal-lxqt = callPackage ./xdg-desktop-portal-lxqt {};

    ### COMPATIBILITY
    lxqt-build-tools_0_13 = callPackage ./lxqt-build-tools {
      version = "0.13.0";
      inherit (pkgs.libsForQt5) qtbase;
    };
    libqtxdg_3_12 = callPackage ./libqtxdg {
      version = "3.12.0";
      lxqt-build-tools = lxqt-build-tools_0_13;
      inherit (pkgs.libsForQt5) qtbase qtsvg;
    };
    libfm-qt_1_4 = callPackage ./libfm-qt {
      version = "1.4.0";
      lxqt-build-tools = lxqt-build-tools_0_13;
      inherit (pkgs.libsForQt5) qttools qtx11extras;
    };
    lxqt-qtplugin_1_4 = callPackage ./lxqt-qtplugin {
      version = "1.4.1";
      lxqt-build-tools = lxqt-build-tools_0_13;
      libqtxdg = libqtxdg_3_12;
      libfm-qt = libfm-qt_1_4;
      inherit (pkgs.libsForQt5) qtbase qtsvg qttools libdbusmenu;
    };
    qtermwidget_1_4 = callPackage ./qtermwidget {
      version = "1.4.0";
      lxqt-build-tools = lxqt-build-tools_0_13;
      inherit (pkgs.libsForQt5) qtbase qttools;
    };

    preRequisitePackages = [
      kdePackages.kwindowsystem # provides some QT plugins needed by lxqt-panel
      kdePackages.libkscreen # provides plugins for screen management software
      pkgs.libfm
      pkgs.libfm-extra
      pkgs.menu-cache
      pkgs.openbox # default window manager
      kdePackages.qtsvg # provides QT plugins for svg icons
    ];

    corePackages = [
      ### BASE
      libqtxdg
      libsysstat
      liblxqt
      qtxdg-tools
      libdbusmenu-lxqt

      ### CORE 1
      libfm-qt
      lxqt-about
      lxqt-admin
      lxqt-config
      lxqt-globalkeys
      lxqt-menu-data
      lxqt-notificationd
      lxqt-openssh-askpass
      lxqt-policykit
      lxqt-powermanagement
      lxqt-qtplugin
      lxqt-session
      lxqt-sudo
      lxqt-themes
      lxqt-wayland-session
      pavucontrol-qt

      ### CORE 2
      lxqt-panel
      lxqt-runner
      pcmanfm-qt
    ];

    optionalPackages = [
      ### LXQt project
      qterminal
      obconf-qt
      lximage-qt
      lxqt-archiver

      ### QtDesktop project
      qps
      screengrab

      ### Default icon theme
      kdePackages.breeze-icons

      ### Screen saver
      pkgs.xscreensaver
    ];

  };
in
makeScope kdePackages.newScope packages
