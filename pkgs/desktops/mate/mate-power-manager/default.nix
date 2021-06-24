{ lib, stdenv, fetchurl, pkg-config, gettext, glib, itstool, libxml2, mate-panel, libnotify, libcanberra-gtk3, dbus-glib, upower, gnome3, gtk3, libtool, polkit, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-power-manager";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fni41p3kraxwjnx9l5mdspng0zib1gfdxwlaiyq31mh4g79yjyj";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libtool
    wrapGAppsHook
  ];

  buildInputs = [
     glib
     itstool
     libxml2
     libcanberra-gtk3
     gtk3
     gnome3.libgnome-keyring
     libnotify
     dbus-glib
     upower
     polkit
     mate-panel
  ];

  configureFlags = [ "--enable-applets" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "The MATE Power Manager";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo chpatrick ];
  };
}
