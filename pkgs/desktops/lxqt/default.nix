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
          --replace "DESTINATION \"\''${LXQT_GRAPHICS_DIR}" "DESTINATION \"share/lxqt/graphhics" \
          --replace "DESTINATION \"\''${QT_PLUGINS_DIR}" "DESTINATION \"lib/qt5/plugins" \
          --replace "\''${LXQT_TRANSLATIONS_DIR}" share/lxqt/translations
        echo ============================
        echo $file
        grep --color=always DESTINATION $file || true
        grep --color=always share/lxqt/translations $file || true
        grep --color=always platformthemes $file || true
      done
      echo --------------------------------------------------------
    '';

    ### BASE
    libqtxdg = callPackage ./base/libqtxdg { };
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

in self
