{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, dde-qt-dbus-factory
, qt5integration
, qt5platform-plugins
, dde-control-center
, deepin-desktop-schemas
, cmake
, qttools
, qtx11extras
, pkg-config
, wrapQtAppsHook
, wrapGAppsHook
, gsettings-qt
, libdbusmenu
, xorg
, gtest
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "dde-dock";
  version = "5.5.81";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-x8U5QPfIykaQLjwbErZiYbZC+JyPQQ+jd6MBjDQyUjs=";
  };

  postPatch = ''
    substituteInPlace plugins/tray/system-trays/systemtrayscontroller.cpp frame/controller/dockpluginscontroller.cpp \
      --replace "/usr/lib/dde-dock/plugins" "/run/current-system/sw/lib/dde-dock/plugins"

    substituteInPlace plugins/show-desktop/showdesktopplugin.cpp frame/window/components/desktop_widget.cpp \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace plugins/{dcc-dock-plugin/settings_module.cpp,tray/system-trays/systemtrayscontroller.cpp} \
      --replace "/usr" "$out"
    '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook
  ];
  dontWrapGApps = true;

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    dde-qt-dbus-factory
    dde-control-center
    deepin-desktop-schemas
    qtx11extras
    gsettings-qt
    libdbusmenu
    xorg.libXcursor
    xorg.libXtst
    xorg.libXdmcp
    gtest
  ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Deepin desktop-environment - dock module";
    homepage = "https://github.com/linuxdeepin/dde-dock";
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
    maintainers = teams.deepin.members;
  };
}
