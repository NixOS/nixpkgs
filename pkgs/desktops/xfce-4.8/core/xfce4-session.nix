{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, dbus_glib, xfconf, xorg, xfce4panel }:

stdenv.mkDerivation rec {
  name = "xfce4-session-4.8.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce4-session/4.8/${name}.tar.bz2";
    sha1 = "636c2983552861a959225e554898675152a4d812";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xorg.iceauth xfce4panel
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Session manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
