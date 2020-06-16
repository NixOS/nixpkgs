{ stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, dde-qt-dbus-factory
, dde-session-ui
, deepin-desktop-base
, deepin-icon-theme
, deepin-wallpapers
, dtkwidget
, gsettings-qt
, libXcursor
, libXrandr
, libXtst
, lightdm
, lightdm_qt
, linux-pam
, qtbase
, qtmultimedia
, qttools
, qtx11extras
, xkeyboard_config
, deepin
}:

mkDerivation rec {
  pname = "dde-session-shell";
  version = "5.3.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1q7x3s1yfybwcp95ryxf1adn9sg6b2g19xy2935jaq78vswv4fzp";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    dde-session-ui
    deepin-desktop-base
    deepin-wallpapers
    dtkwidget
    gsettings-qt
    libXcursor
    libXrandr
    libXtst
    lightdm
    lightdm_qt
    linux-pam
    qtmultimedia
    qtx11extras
    xkeyboard_config
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    fixPath $out /etc/deepin/greeters.d \
      CMakeLists.txt \
      files/deepin-greeter \
      src/lightdm-deepin-greeter/deepin-greeter \
      src/lightdm-deepin-greeter/lightdm-deepin-greeter.pro

    fixPath $out /usr/bin/dde-lock                             files/com.deepin.dde.lockFront.service
    fixPath $out /usr/bin/dde-shutdown                         files/com.deepin.dde.shutdownFront.service
    fixPath $out /usr/bin/deepin-greeter                       files/lightdm-deepin-greeter.desktop
    fixPath $out /usr/bin/lightdm-deepin-greeter               scripts/lightdm-deepin-greeter
    fixPath $out /usr/lib/deepin-daemon/greeter-display-daemon scripts/lightdm-deepin-greeter
    fixPath $out /usr/share/dde-session-shell                  src/app/dde-lock.cpp
    fixPath $out /usr/share/dde-session-shell                  src/app/dde-shutdown.cpp
    fixPath $out /usr/share/dde-session-shell                  src/app/lightdm-deepin-greeter.cpp
    fixPath $out /usr/share/dde-session-shell                  src/session-widgets/lockcontent.cpp

    # This file seems not to be installed. Nonetheless...
    fixPath $out /usr/share/dde-session-ui/dde-shutdown.conf   src/global_util/constants.h

    ###!fixPath ${deepin-desktop-base} /etc/deepin-version src/widgets/logowidget.cpp
    fixPath ${dde-session-ui} /usr/share/dde-session-ui/dde-session-ui.conf src/global_util/constants.h
    fixPath ${xkeyboard_config} /usr/share/X11/xkb/rules/base.xml src/global_util/xkbparser.h

    substituteInPlace src/widgets/fullscreenbackground.cpp \
      --replace /usr/share/backgrounds/{default_background.jpg,deepin/desktop.jpg}

    fixPath ${deepin-wallpapers} /usr/share/backgrounds src/dde-shutdown/view/contentwidget.cpp
    fixPath ${deepin-wallpapers} /usr/share/backgrounds src/widgets/fullscreenbackground.cpp
    fixPath ${deepin-wallpapers} /usr/share/wallpapers src/session-widgets/userinfo.cpp
    fixPath ${deepin-wallpapers} /usr/share/wallpapers src/widgets/fullscreenbackground.cpp

    ###!substituteInPlace src/app/lightdm-deepin-greeter.cpp --replace /usr/share/icons/deepin ${deepin-icon-theme}/share/icons/bloom

    # It seems there is not a default cursor theme in NixOS. Nonetheless...
    substituteInPlace src/global_util/constants.h --replace {/usr,/run/current-system/sw}/share/icons/default/index.theme

    # https://github.com/linuxdeepin/dde-session-shell/issues/3
    sed -i '/darrowrectangle/d' CMakeLists.txt src/widgets/widgets.pri
    ###!sed -i 's/include "darrowrectangle.h"/include <darrowrectangle.h>/' src/widgets/errortooltip.h

    # We don't have common-auth
    substituteInPlace src/libdde-auth/authagent.cpp --replace common-auth system-login

    # TODO: fix
    #    /etc/deepin/dde-session-ui.conf
    #    /etc/deepin/dde-shutdown.conf
    #    /etc/deepin/dde.conf
    #    /etc/deepin/no_suspend
    #    /etc/lightdm
    #    /etc/lightdm/deepin/qt-theme.ini
    #    /etc/lightdm/lightdm-deepin-greeter.conf
    #    /usr/bin/deepin-system-monitor
    #    /var/lib/AccountsService/users
    #    /var/lib/lightdm/lightdm-deepin-greeter
  '';

  postInstall = ''
    chmod +x $out/bin/deepin-greeter
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin desktop-environment - session-shell module";
    homepage = "https://github.com/linuxdeepin/dde-session-shell";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
