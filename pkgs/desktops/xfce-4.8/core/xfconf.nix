{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, dbus_glib }:

stdenv.mkDerivation rec {
  name = "xfconf-4.8.0";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfconf/4.8/${name}.tar.bz2";
    sha1 = "3f560b11d618171805bfb9e6a8290185c7ee5dcd";
  };

  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  propagatedBuildInputs = [ dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = "GPLv2";
  };
}
