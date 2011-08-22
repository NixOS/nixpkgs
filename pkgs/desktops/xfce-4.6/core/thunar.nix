{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util
, dbus_glib, libstartup_notification, xfconf, hal, xfce4panel
, gamin }:

stdenv.mkDerivation rec {
  name = "thunar-1.0.2";
  
  src = fetchurl {
    url = http://www.xfce.org/archive/xfce/4.6.2/src/Thunar-1.0.2.tar.bz2;
    sha1 = "f7ae00c32402e4bc502aba15477b78e2c558c7c3";
  };

  buildInputs =
    [ pkgconfig intltool exo gtk libxfce4util
      dbus_glib libstartup_notification xfconf xfce4panel gamin
    ];

  propagatedBuildInputs = [ hal ];

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Xfce file manager";
    license = "GPLv2+";
  };
}
