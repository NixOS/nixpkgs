{ v, h, stdenv, fetchXfce, pkgconfig, intltool, glib, libxfce4util, dbus_glib }:

stdenv.mkDerivation rec {
  name = "xfconf-${v}";
  src = fetchXfce.core name h;

  #TODO: no perl bingings yet (ExtUtils::Depends, ExtUtils::PkgConfig, Glib)
  buildInputs = [ pkgconfig intltool glib libxfce4util ];
  propagatedBuildInputs = [ dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/projects/xfconf;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = "GPLv2";
  };
}
