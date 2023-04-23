{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, qt5integration
, qt5platform-plugins
, pkg-config
, cmake
, dde-dock
, dde-qt-dbus-factory
, deepin-gettext-tools
, gsettings-qt
, lightdm_qt
, qttools
, qtx11extras
, util-linux
, xorg
, pcre
, libselinux
, libsepol
, wrapQtAppsHook
, gtest
, xkeyboard_config
, qtbase
, dbus
}:

stdenv.mkDerivation rec {
  pname = "dde-session-ui";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-3lW/M07b6gXzGcvQYB+Ojqdq7TfJBaMIKfmfG7o3wWg=";
  };

  postPatch = ''
    substituteInPlace widgets/fullscreenbackground.cpp \
      --replace "/usr/share/backgrounds" "/run/current-system/sw/share/backgrounds" \
      --replace "/usr/share/wallpapers" "/run/current-system/sw/share/wallpapers"

    substituteInPlace global_util/xkbparser.h \
      --replace "/usr/share/X11/xkb/rules/base.xml" "${xkeyboard_config}/share/X11/xkb/rules/base.xml"

    substituteInPlace dde-warning-dialog/com.deepin.dde.WarningDialog.service dde-osd/files/dde-osd.desktop dde-welcome/com.deepin.dde.welcome.service \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace dde-osd/notification/bubbletool.cpp \
      --replace "/usr/share" "/run/current-system/sw/share"

    substituteInPlace dde-osd/files/{com.deepin.dde.Notification.service,com.deepin.dde.freedesktop.Notification.service,com.deepin.dde.osd.service} \
      --replace "/usr/bin/dbus-send" "${dbus}/bin/dbus-send" \
      --replace "/usr/share" "$out/share"

     substituteInPlace dde-lowpower/main.cpp dmemory-warning-dialog/main.cpp dde-touchscreen-dialog/main.cpp dnetwork-secret-dialog/main.cpp dde-suspend-dialog/main.cpp \
    dde-warning-dialog/main.cpp dde-bluetooth-dialog/main.cpp dde-welcome/main.cpp dde-hints-dialog/main.cpp dde-osd/main.cpp dde-wm-chooser/main.cpp \
    dde-license-dialog/{content.cpp,main.cpp} dmemory-warning-dialog/com.deepin.dde.MemoryWarningDialog.service \
      --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    deepin-gettext-tools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    dde-dock
    dde-qt-dbus-factory
    gsettings-qt
    qtx11extras
    pcre
    xorg.libXdmcp
    util-linux
    libselinux
    libsepol
    gtest
  ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    for binary in $out/lib/deepin-daemon/*; do
      wrapProgram $binary "''${qtWrapperArgs[@]}"
    done
  '';

  meta = with lib; {
    description = "Deepin desktop-environment - Session UI module";
    homepage = "https://github.com/linuxdeepin/dde-session-ui";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
