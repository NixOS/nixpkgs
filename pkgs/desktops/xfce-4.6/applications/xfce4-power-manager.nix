{ stdenv, fetchurl, pkgconfig, intltool, gtk, dbus_glib, xfconf
, libxfcegui4, libxfce4util, libnotify, xfce4panel }:

stdenv.mkDerivation rec {
  name = "xfce4-power-manager-0.8.5";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/src/apps/xfce4-power-manager/0.8/${name}.tar.bz2";
    sha1 = "b1ce0f120733ec1a6267d50ba5c2990bbbbccfd4";
  };

  buildInputs =
    [ pkgconfig intltool gtk dbus_glib xfconf libxfcegui4 libxfce4util
      libnotify xfce4panel
    ];

  NIX_CFLAGS_COMPILE = "-I${libxfcegui4}/include/xfce4";

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-power-manager;
    description = "A power manager for the Xfce Desktop Environment";
    license = "GPLv2+";
  };
}
