{ v, h, stdenv, fetchXfce, pkgconfig, intltool, dbus_glib, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "tumbler-${v}";
  src = fetchXfce.core name h;

  buildInputs = [ pkgconfig intltool dbus_glib gdk_pixbuf ];

  meta = {
    homepage = http://git.xfce.org/xfce/tumbler/;
    description = "A D-Bus thumbnailer service";
    license = "GPLv2";
  };
}
