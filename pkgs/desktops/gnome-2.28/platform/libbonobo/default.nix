{stdenv, fetchurl, flex, bison, pkgconfig, glib, dbus_glib, libxml2, popt, intltool, ORBit2}:

stdenv.mkDerivation {
  name = "libbonobo-2.24.2";
  src = fetchurl {
    url = mirror://gnome/sources/libbonobo/2.24/libbonobo-2.24.2.tar.bz2;
    sha256 = "1gr85amd271z0lbr68crcsc24rx1pa5k20f67y3y2mx664527h4m";
  };
  buildInputs = [ flex bison pkgconfig glib dbus_glib libxml2 popt intltool ORBit2 ];
}
