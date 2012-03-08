{stdenv, fetchurl, pkgconfig, dbus_glib, libxklavier, glib, gtk, intltool, GConf, libglade}:

stdenv.mkDerivation {
  name = "libgnomekbd-2.32.0";

  src = fetchurl {
    url = mirror://gnome/sources/libgnomekbd/2.32/libgnomekbd-2.32.0.tar.bz2;
    sha256 = "0mnjhdryx94c106fghzz01dyc1vlp16wn6sajvpxffnqqx62rmfx";
  };

  buildInputs = [ pkgconfig dbus_glib libxklavier glib gtk intltool GConf libglade ];
}
