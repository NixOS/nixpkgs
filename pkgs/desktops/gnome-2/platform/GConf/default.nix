{ stdenv, fetchurl, pkgconfig, dbus_glib, glib, ORBit2, libxml2
, polkit, intltool, dbus_libs }:

stdenv.mkDerivation {
  name = "GConf-2.28.1";

  src = fetchurl {
    url = mirror://gnome/sources/GConf/2.28/GConf-2.28.1.tar.bz2;
    sha256 = "001h9gngz31gnvs6mjyazdibhdqmw1wwk88n934b0mv013wpgi2k";
  };

  buildInputs = [ pkgconfig ORBit2 dbus_libs dbus_glib libxml2 polkit intltool ];
  propagatedBuildInputs = [ glib ];
}
