{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, dbus_glib, libstartup_notification, xfconf, xfce4panel, udev, libnotify }:

stdenv.mkDerivation rec {
  version = "1.2.3";
  name = "thunar-${version}";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/thunar/1.2/Thunar-${version}.tar.bz2";
    sha1 = "a05d0e14515d70c5ad94cca881822a707d366863";
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
