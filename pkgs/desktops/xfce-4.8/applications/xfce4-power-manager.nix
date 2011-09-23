{ stdenv, fetchurl, pkgconfig, intltool, gtk, dbus_glib, xfconf
, libxfce4ui, libxfce4util, libnotify, xfce4panel }:

stdenv.mkDerivation rec {
  name = "xfce4-power-manager-1.0.10";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/xfce4-power-manager/1.0/${name}.tar.bz2";
    sha1 = "64dd7a8fae9cd1cbcf6403d2f51f2281f38cca05";
  };

  buildInputs =
    [ pkgconfig intltool gtk dbus_glib xfconf libxfce4ui libxfce4util
      libnotify xfce4panel
    ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-power-manager;
    description = "A power manager for the Xfce Desktop Environment";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
