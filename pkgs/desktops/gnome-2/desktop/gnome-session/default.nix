{ stdenv, fetchurl, pkgconfig, dbus_glib, cairo, dbus, gtk, pango, atk, libXau, libXtst, inputproto
, intltool, libglade, startup_notification, GConf}:

stdenv.mkDerivation {
  name = "gnome-session-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/gnome-session/2.28/gnome-session-2.28.0.tar.bz2;
    sha256 = "032wfr70z61fnfk7snw8kck914z6y4wxr6v0dcgil3q9zc29ms43";
  };
  buildInputs = [ pkgconfig dbus_glib gtk libXau libXtst inputproto intltool libglade startup_notification GConf ];
  CPPFLAGS = "-I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${dbus_glib}/include/dbus-1.0 "+
             "-I${pango}/include/pango-1.0 -I${atk}/include/atk-1.0 -I${cairo}/include/cairo "+
	     "-I${dbus.libs}/include/dbus-1.0 -I${dbus.libs}/lib/dbus-1.0/include "+
	     "-I${libglade}/include/libglade-2.0";
  LIBS = "-lglade-2.0 -ldbus-glib-1";
}
