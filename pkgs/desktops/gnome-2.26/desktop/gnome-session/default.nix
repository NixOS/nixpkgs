{ stdenv, fetchurl, pkgconfig, dbus_glib, cairo, dbus, gtk, pango, atk, libXau, libXtst, inputproto
, intltool, libglade, startup_notification, GConf}:

stdenv.mkDerivation {
  name = "gnome-session-2.26.1";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/gnome-session-2.26.1.tar.bz2;
    sha256 = "0cmw1p07gw7bjiq31mmm7fjhr84zq7x7rzbphfws4sgd8bn09qrm";
  };
  buildInputs = [ pkgconfig dbus_glib gtk libXau libXtst inputproto intltool libglade startup_notification GConf ];
  CPPFLAGS = "-I${gtk}/include/gtk-2.0 -I${gtk}/lib/gtk-2.0/include -I${dbus_glib}/include/dbus-1.0 "+
             "-I${pango}/include/pango-1.0 -I${atk}/include/atk-1.0 -I${cairo}/include/cairo "+
	     "-I${dbus.libs}/include/dbus-1.0 -I${dbus.libs}/lib/dbus-1.0/include "+
	     "-I${libglade}/include/libglade-2.0";
  LIBS = "-lglade-2.0 -ldbus-glib-1";
}
