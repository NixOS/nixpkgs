{ stdenv, fetchurl, pkgconfig, intltool, gtk, dbus_glib, libxfce4util
, libxfce4ui, libwnck, xfconf, garcon, libnotify, exo }:

stdenv.mkDerivation rec {
  name = "xfdesktop-4.8.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfdesktop/4.8/${name}.tar.bz2";
    sha1 = "fe7d71bb502197b0353b952947826a5a50ab13bc";
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
  };
}
