{stdenv, fetchurl, pkgconfig, dbus_glib, libxklavier, glib, gtk, intltool, GConf, libglade}:

stdenv.mkDerivation {
  name = "libgnomekbd-2.26.0";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/libgnomekbd-2.26.0.tar.bz2;
    sha256 = "0krn24c7c207vhsaizz5vybyni2rc2x245p3hv9sivgayd93b996";
  };
  buildInputs = [ pkgconfig dbus_glib libxklavier glib gtk intltool GConf libglade ];
}
