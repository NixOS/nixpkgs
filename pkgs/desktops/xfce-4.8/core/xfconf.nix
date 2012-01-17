{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, dbus_glib }:

stdenv.mkDerivation rec {
  name = "xfconf-4.8.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfconf/4.8/${name}.tar.bz2";
    sha1 = "aeab124f7c548e387b37a5476e594ef559515533";
  };

  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  propagatedBuildInputs = [ dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = "GPLv2";
  };
}
