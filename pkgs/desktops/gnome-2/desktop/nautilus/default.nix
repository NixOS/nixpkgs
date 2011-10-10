{stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif, gtk, gnome_desktop, libunique, intltool, GConf}:

stdenv.mkDerivation {
  name = "nautilus-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/nautilus/2.28/nautilus-2.28.0.tar.bz2;
    sha256 = "0wmskjxf231r2vra22zy02561gh5q10pj3lhzya13dvlliyv4q9p";
  };
  buildInputs = [ pkgconfig libxml2 dbus_glib shared_mime_info libexif gtk gnome_desktop libunique intltool GConf ];
}
