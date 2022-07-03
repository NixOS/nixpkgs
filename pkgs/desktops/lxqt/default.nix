{ pkgs, makeScope, libsForQt5, qt5 }:
let
  packages = self: with self; {

    # Update script tailored to LXQt packages from git repository
    lxqtUpdateScript = { pname, version, src }:
      pkgs.gitUpdater {
        inherit pname version;
        attrPath = "lxqt.${pname}";
      };

    # For compiling information, see:
    # - https://github.com/lxqt/lxqt/wiki/Building-from-source

    ### BASE
    libqtxdg = callPackage ./libqtxdg {};
    lxqt-build-tools = callPackage ./lxqt-build-tools {};
    libsysstat = callPackage ./libsysstat {};
    liblxqt = callPackage ./liblxqt {};
    qtxdg-tools = callPackage ./qtxdg-tools {};

    ### CORE 1
    libfm-qt = callPackage ./libfm-qt {};
    lxqt-about = callPackage ./lxqt-about {};
    lxqt-admin = callPackage ./lxqt-admin {};
    lxqt-config = callPackage ./lxqt-config {};
    lxqt-globalkeys = callPackage ./lxqt-globalkeys {};
    lxqt-notificationd = callPackage ./lxqt-notificationd {};
    lxqt-openssh-askpass = callPackage ./lxqt-openssh-askpass {};
    lxqt-policykit = callPackage ./lxqt-policykit {};
    lxqt-powermanagement = callPackage ./lxqt-powermanagement {};
    lxqt-qtplugin = callPackage ./lxqt-qtplugin {};
    lxqt-session = callPackage ./lxqt-session {};
    lxqt-sudo = callPackage ./lxqt-sudo {};
    lxqt-themes = callPackage ./lxqt-themes {};
    pavucontrol-qt = libsForQt5.callPackage ./pavucontrol-qt {};
    qtermwidget = callPackage ./qtermwidget {};

    ### CORE 2
    lxqt-panel = callPackage ./lxqt-panel {};
    lxqt-runner = callPackage ./lxqt-runner {};
    pcmanfm-qt = callPackage ./pcmanfm-qt {};

    ### OPTIONAL
    qterminal = callPackage ./qterminal {};
    compton-conf = qt5.callPackage ./compton-conf {};
    obconf-qt = callPackage ./obconf-qt {};
    lximage-qt = callPackage ./lximage-qt {};
    qps = callPackage ./qps {};
    screengrab = callPackage ./screengrab {};
    qlipper = callPackage ./qlipper {};
    lxqt-archiver = callPackage ./lxqt-archiver {};
    xdg-desktop-portal-lxqt = callPackage ./xdg-desktop-portal-lxqt {};

    preRequisitePackages = [
      libsForQt5.kwindowsystem # provides some QT5 plugins needed by lxqt-panel
      libsForQt5.libkscreen # provides plugins for screen management software
      pkgs.libfm
      pkgs.libfm-extra
      pkgs.lxmenu-data
      pkgs.menu-cache
      pkgs.openbox # default window manager
      qt5.qtsvg # provides QT5 plugins for svg icons
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
      obconf-qt
      lximage-qt
      lxqt-archiver

      ### QtDesktop project
      qps
      screengrab

      ### Default icon theme
      libsForQt5.breeze-icons

      ### Screen saver
      pkgs.xscreensaver
    ];

  };
in
makeScope libsForQt5.newScope packages
