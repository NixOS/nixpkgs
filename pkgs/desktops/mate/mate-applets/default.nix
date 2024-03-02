{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, dbus-glib
, glib
, gtk3
, gtksourceview3
, gucharmap
, libmateweather
, libnl
, libwnck
, libgtop
, libxml2
, libnotify
, mate-desktop
, mate-panel
, polkit
, upower
, wirelesstools
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-applets";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Orj2HbN23DM85MGHIsY6B/qz6OEnK34OCXrUWXsXwsI=";
  };

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    dbus-glib
    gtk3
    gtksourceview3
    gucharmap
    hicolor-icon-theme
    libgtop
    libmateweather
    libnl
    libnotify
    libwnck
    libxml2
    mate-desktop # for org.mate.lockdown
    mate-panel
    polkit
    upower
    wirelesstools
  ];

  configureFlags = [ "--enable-suid=no" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Applets for use with the MATE panel";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
