{ pkgs, newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  self = rec {

    # For compiling information, see:
    # - https://github.com/lxde/lxqt/wiki/Building-from-source
  
    standardPatch = ''
      for file in $(find . -name CMakeLists.txt); do
        substituteInPlace $file \
          --replace "DESTINATION \''${LXQT_ETC_XDG_DIR}" "DESTINATION etc/xdg" \
          --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg" \
          --replace "DESTINATION \"\''${LXQT_SHARE_DIR}" "DESTINATION \"share/lxqt" \
          --replace "DESTINATION \"\''${LXQT_GRAPHICS_DIR}" "DESTINATION \"share/lxqt/graphics" \
          --replace "DESTINATION \"\''${QT_PLUGINS_DIR}" "DESTINATION \"lib/qt5/plugins" \
          --replace "\''${LXQT_TRANSLATIONS_DIR}" share/lxqt/translations
        echo ============================
        echo $file
        grep --color=always DESTINATION $file || true
        grep --color=always share/lxqt/translations $file || true
        grep --color=always platform $file || true
      done
      echo --------------------------------------------------------
    '';

    ### BASE
    libqtxdg = callPackage ./base/libqtxdg { };
    lxqt-build-tools = callPackage ./base/lxqt-build-tools { };
    libsysstat = callPackage ./base/libsysstat { };
    liblxqt = callPackage ./base/liblxqt { };

    ### CORE 1
    libfm-qt = callPackage ./core/libfm-qt { };
    lxqt-about = callPackage ./core/lxqt-about { };
    lxqt-admin = callPackage ./core/lxqt-admin { };
    lxqt-common = callPackage ./core/lxqt-common { };
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
    pavucontrol-qt = callPackage ./core/pavucontrol-qt { };
    qtermwidget = callPackage ./core/qtermwidget { };

    ### CORE 2
    lxqt-panel = callPackage ./core/lxqt-panel { };
    lxqt-runner = callPackage ./core/lxqt-runner { };
    pcmanfm-qt = callPackage ./core/pcmanfm-qt { };

    ### OPTIONAL
    qterminal = callPackage ./optional/qterminal { };
    compton-conf = callPackage ./optional/compton-conf { };
    obconf-qt = callPackage ./optional/obconf-qt { };
    lximage-qt = callPackage ./optional/lximage-qt { };
    qps = callPackage ./optional/qps { };
    screengrab = callPackage ./optional/screengrab { };
    qlipper = callPackage ./optional/qlipper { };

    preRequisitePackages = [
      pkgs.gvfs # virtual file systems support for PCManFM-QT
      pkgs.kde5.kwindowsystem # provides some QT5 plugins needed by lxqt-panel
      pkgs.kde5.libkscreen # provides plugins for screen management software
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
      lxqt-common
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
      pkgs.kde5.oxygen-icons5

      ### Screen saver
      pkgs.xscreensaver
    ];

  };

in self
