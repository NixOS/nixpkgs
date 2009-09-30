{stdenv, fetchurl, pkgconfig, dbus_glib, libxklavier, glib, gtk, intltool, GConf, libglade}:

stdenv.mkDerivation {
  name = "libgnomekbd-2.28.0";
  src = fetchurl {
    url = mirror:/gnome/sources/libgnomekbd/2.28/libgnomekbd-2.28.0.tar.bz2;
    sha256 = "0s1664nwsavwjfmg4wkhvrpz9qxw04nsx5l8z87nlrny3312rnkj"
  };
  buildInputs = [ pkgconfig dbus_glib libxklavier glib gtk intltool GConf libglade ];
}
