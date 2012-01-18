{ stdenv, fetchurl, pkgconfig, intltool, gtk, dbus_glib, libxfce4util
, libxfce4ui, libwnck, xfconf, garcon, libnotify, exo }:

stdenv.mkDerivation rec {
  name = "xfdesktop-4.8.3";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfdesktop/4.8/${name}.tar.bz2";
    sha1 = "b3af72a69627f860f22b37d021efd81e4e37eb55";
  };

  buildInputs =
    [ pkgconfig intltool gtk dbus_glib libxfce4util libxfce4ui libwnck xfconf
      garcon libnotify exo
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce desktop manager";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
