{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, dbus_glib, xfconf, xorg, xfce4panel }:

stdenv.mkDerivation rec {
  name = "xfce4-session-4.8.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce4-session/4.8/${name}.tar.bz2";
    sha1 = "a33534e53fa36a38a1f9bd164469a9fb62c765a7";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xorg.iceauth xfce4panel
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Session manager for Xfce";
    license = "GPLv2+";
  };
}
