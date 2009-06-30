{stdenv, fetchurl, flex, bison, pkgconfig, glib, dbus_glib, libxml2, popt, intltool, ORBit2}:

stdenv.mkDerivation {
  name = "libbonobo-2.24.1";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/libbonobo-2.24.1.tar.bz2;
    sha256 = "0x0jx5bf9nrh7djq90vj7zryixgws6ir8py6pczwjb3bp1carcj2";
  };
  buildInputs = [ flex bison pkgconfig glib dbus_glib libxml2 popt intltool ORBit2 ];
}
