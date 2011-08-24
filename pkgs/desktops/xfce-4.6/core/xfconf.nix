{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, dbus_glib }:

stdenv.mkDerivation rec {
  name = "xfconf-4.6.2";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha1 = "2b9656a1b7f323d2600ddc929191afb50c8018f8";
  };

  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  propagatedBuildInputs = [ dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = "GPLv2";
  };
}
