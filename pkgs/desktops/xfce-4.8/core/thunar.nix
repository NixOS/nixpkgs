{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, dbus_glib, libstartup_notification, xfconf, xfce4panel, udev, libnotify }:

stdenv.mkDerivation rec {
  name = "thunar-1.2.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/thunar/1.2/Thunar-1.2.2.tar.bz2";
    sha1 = "314e3d53ec7be1ea578da4d842ecc8dc5958b1bd";
  };

  buildInputs =
    [ pkgconfig intltool gtk exo libxfce4util libxfce4ui
      dbus_glib libstartup_notification xfconf xfce4panel udev libnotify
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Xfce file manager";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
