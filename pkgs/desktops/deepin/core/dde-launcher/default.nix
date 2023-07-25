{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, dde-qt-dbus-factory
, qt5integration
, qt5platform-plugins
, cmake
, qttools
, qtx11extras
, pkg-config
, wrapQtAppsHook
, wrapGAppsHook
, gsettings-qt
, gtest
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "dde-launcher";
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-Td8R91892tgJx7FLV2IZ/aPBzDb+o6EYKpk3D8On7Ag=";
  };

  postPatch = ''
    #fix build with new dtk(https://github.com/linuxdeepin/dde-launcher/pull/369)
    substituteInPlace src/windowedframe.h \
      --replace "#include <dregionmonitor.h>" " "
    substituteInPlace src/boxframe/{backgroundmanager.cpp,boxframe.cpp} \
      --replace "/usr/share/backgrounds" "/run/current-system/sw/share/backgrounds"
    substituteInPlace dde-launcher.desktop dde-launcher-wapper src/dbusservices/com.deepin.dde.Launcher.service \
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
    qtx11extras
    gsettings-qt
    gtest
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Deepin desktop-environment - Launcher module";
    homepage = "https://github.com/linuxdeepin/dde-launcher";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
