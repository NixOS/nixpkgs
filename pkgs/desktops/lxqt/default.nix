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

in self
