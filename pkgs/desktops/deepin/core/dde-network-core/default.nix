{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, dtkwidget
, dde-dock
, dde-control-center
, dde-session-shell
, dde-qt-dbus-factory
, gsettings-qt
, gio-qt
, networkmanager-qt
, glib
, pcre
, util-linux
, libselinux
, libsepol
, dbus
, gtest
, qtbase
}:
stdenv.mkDerivation rec {
  pname = "dde-network-core";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-ysmdB9CT7mhN/0r8CRT4FQsK12HkhjbezGXwWiNScqg=";
  };

  postPatch = ''
    substituteInPlace dock-network-plugin/networkplugin.cpp dcc-network-plugin/dccnetworkmodule.cpp dss-network-plugin/network_module.cpp \
      --replace "/usr/share" "$out/share"
    substituteInPlace dss-network-plugin/notification/bubbletool.cpp \
      --replace "/usr/share" "/run/current-system/sw/share"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    dde-dock
    dde-control-center
    dde-session-shell
    dde-qt-dbus-factory
    gsettings-qt
    gio-qt
    networkmanager-qt
    glib
    pcre
    util-linux
    libselinux
    libsepol
    gtest
  ];

  cmakeFlags = [
    "-DVERSION=${version}"
  ];

  meta = with lib; {
    description = "DDE network library framework";
    homepage = "https://github.com/linuxdeepin/dde-network-core";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
