{stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif, gtk, gnome_desktop, libunique, intltool, GConf}:

stdenv.mkDerivation {
  name = "nautilus-2.26.3";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/nautilus-2.26.3.tar.bz2;
    sha256 = "1qfzw3aqyixybvxlj768l3a1knp0f0knpvs5566advpil1i771qx";
  };
  buildInputs = [ pkgconfig libxml2 dbus_glib shared_mime_info libexif gtk gnome_desktop libunique intltool GConf ];
}
