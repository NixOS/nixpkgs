{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, dbus
, dde-daemon
, dde-dock
, dde-qt-dbus-factory
, deepin
, deepin-desktop-base
, deepin-desktop-schemas
, deepin-gettext-tools
, deepin-icon-theme
, deepin-wallpapers
, dtkwidget
, glib
, gnugrep
, gsettings-qt
, lightdm_qt
#, onboard
, qtmultimedia
, qtsvg
, qttools
, qtx11extras
#, setxkbmap
, utillinux
, which
, xkeyboard_config
, xorg
, xrandr
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "dde-session-ui";
  version = "5.3.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0n60jr7ivjh1h8h4jlk7wg9mjimsh4di1sr32z1j9n70y8vmvgx2";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    deepin-gettext-tools
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    dbus
    dde-daemon
    dde-dock
    dde-qt-dbus-factory
    deepin-desktop-base
    deepin-desktop-schemas
    deepin-icon-theme
    deepin-wallpapers
    dtkwidget
    gnugrep
    gsettings-qt
    lightdm_qt
    #onboard
    qtmultimedia
    qtsvg
    qtx11extras
    #setxkbmap
    utillinux
    which
    xkeyboard_config
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXtst
    xrandr
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    patchShebangs translate_generation.sh translate_desktop.sh

    substituteInPlace translate_desktop.sh --replace "/usr/bin/deepin-desktop-ts-convert" "deepin-desktop-ts-convert"

    fixPath ${deepin-desktop-base} /etc/deepin-version dde-welcome/utils.cpp
    fixPath ${deepin-desktop-base} /etc/deepin-version lightdm-deepin-greeter/view/logowidget.cpp

    # ??????????????????????????
    find -type f -exec sed -i -e "s,path = /etc,path = $out/etc," {} +
    find -type f -exec sed -i -e "s,path = /usr,path = $out," {} +

    find -type f -exec sed -i -e "s,/usr/share/dde-session-ui,$out/share/dde-session-ui," {} +

    substituteInPlace dde-notification-plugin/notifications/notifications.pro --replace /usr/include/dde-dock ${dde-dock}/include/dde-dock

    substituteInPlace dde-osd/dde-osd_autostart.desktop --replace "Exec=/usr/lib/deepin-daemon/dde-osd" "Exec=$out/lib/deepin-daemon/dde-osd"
    substituteInPlace dde-osd/com.deepin.dde.osd.service --replace "Exec=/usr/lib/deepin-daemon/dde-osd" "Exec=$out/lib/deepin-daemon/dde-osd"
    substituteInPlace dde-lock/com.deepin.dde.lockFront.service --replace "Exec=/usr/bin/dde-lock" "Exec=$out/bin/dde-lock"
    substituteInPlace dmemory-warning-dialog/com.deepin.dde.MemoryWarningDialog.service --replace "Exec=/usr/bin/dmemory-warning-dialog" "Exec=$out/bin/dmemory-warning-dialog"
    substituteInPlace dde-warning-dialog/com.deepin.dde.WarningDialog.service --replace "Exec=/usr/lib/deepin-daemon/dde-warning-dialog" "Exec=$out/lib/deepin-daemon/dde-warning-dialog"
    substituteInPlace dde-shutdown/com.deepin.dde.shutdownFront.service --replace "Exec=/usr/bin/dde-shutdown" "Exec=$out/bin/dde-shutdown"
    substituteInPlace dde-welcome/com.deepin.dde.welcome.service --replace "Exec=/usr/lib/deepin-daemon/dde-welcome" "Exec=$out/lib/deepin-daemon/dde-welcome"
    substituteInPlace session-ui-guardien/session-ui-guardien.desktop --replace "Exec=/usr/bin/session-ui-guardien" "Exec=$out/bin/session-ui-guardien"
    substituteInPlace lightdm-deepin-greeter/lightdm-deepin-greeter.desktop --replace "Exec=/usr/bin/deepin-greeter" "Exec=$out/bin/deepin-greeter"
    substituteInPlace misc/applications/deepin-toggle-desktop.desktop.in --replace "Exec=/usr/lib/deepin-daemon/desktop-toggle" "Exec=${dde-daemon}/lib/deepin-daemon/desktop-toggle"

    # Uncomment (and remove space after $) after packaging deepin-system-monitor
    #substituteInPlace dde-shutdown/view/contentwidget.cpp --replace "/usr/bin/deepin-system-monitor" "$ {deepin-system-monitor}/bin/deepin-system-monitor"

    substituteInPlace dde-offline-upgrader/main.cpp --replace "dbus-send" "${dbus}/bin/dbus-send"
    substituteInPlace dde-osd/kblayoutindicator.cpp --replace "dbus-send" "${dbus}/bin/dbus-send"
    substituteInPlace dde-shutdown/view/contentwidget.cpp --replace "/usr/share/backgrounds/deepin" "${deepin-wallpapers}/share/backgrounds/deepin"
    substituteInPlace dde-welcome/mainwidget.cpp --replace "dbus-send" "${dbus}/bin/dbus-send"
    substituteInPlace dmemory-warning-dialog/src/buttondelegate.cpp --replace "dbus-send" "${dbus}/bin/dbus-send"
    substituteInPlace dmemory-warning-dialog/src/buttondelegate.cpp --replace "kill" "${utillinux}/bin/dbus-send"
    substituteInPlace global_util/xkbparser.h --replace "/usr/share/X11/xkb/rules/base.xml" "${xkeyboard_config}/share/X11/xkb/rules/base.xml"
    substituteInPlace lightdm-deepin-greeter/main.cpp --replace "/usr/share/icons/deepin" "${deepin-icon-theme}/share/icons/deepin"
    substituteInPlace lightdm-deepin-greeter/scripts/00-xrandr --replace "egrep" "${gnugrep}/bin/egrep"
    substituteInPlace lightdm-deepin-greeter/scripts/00-xrandr --replace "xrandr" "${xrandr}/bin/xrandr"
    substituteInPlace lightdm-deepin-greeter/scripts/lightdm-deepin-greeter --replace "/usr/bin/lightdm-deepin-greeter" "$out/bin/lightdm-deepin-greeter"
    substituteInPlace session-ui-guardien/guardien.cpp --replace "dde-lock" "$out/bin/dde-lock"
    substituteInPlace session-ui-guardien/guardien.cpp --replace "dde-shutdown" "$out/bin/dde-shutdown"
    substituteInPlace dde-lock/lockworker.cpp --replace "dde-switchtogreeter" "$out/bin/dde-switchtogreeter"
    substituteInPlace dde-lock/lockworker.cpp --replace "which" "${which}/bin/which"
    substituteInPlace widgets/fullscreenbackground.cpp --replace "/usr/share/wallpapers/deepin" "${deepin-wallpapers}/share/wallpapers/deepin"

    # fix default background url
    substituteInPlace widgets/fullscreenbackground.cpp --replace "/usr/share/backgrounds/default_background.jpg" "${deepin-wallpapers}/share/backgrounds/deepin/desktop.jpg"

    # NOTES
    # - on deepin linux /usr/share/icons/default/index.theme is controlled by alternatives, without an equivalent mechanism in NixOS
    # - do not wrap dde-dman-portal related files: it appears it has been removed: https://github.com/linuxdeepin/dde-session-ui/commit/3bd028cf135ad22c784c0146e447ef34a69af768
  '';

  dontWrapQtApps = true;

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}

    gappsWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
    )
  '';

  postFixup = ''
    # wrapGAppsHook or wrapQtAppsHook does not work with binaries outside of $out/bin or $out/libexec
    for binary in $out/lib/deepin-daemon/*; do
      wrapProgram $binary "''${gappsWrapperArgs[@]}"
    done

    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin desktop-environment - Session UI module";
    homepage = "https://github.com/linuxdeepin/dde-session-ui";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
