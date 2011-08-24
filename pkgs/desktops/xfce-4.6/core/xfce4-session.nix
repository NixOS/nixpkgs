{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfcegui4
, libwnck, dbus_glib, xfconf, libglade, xorg }:

stdenv.mkDerivation rec {
  name = "xfce4-session-4.6.2";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha1 = "2a5778a1543f97845f118a186e2dbb8a8ea3ff4b";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfcegui4 libwnck dbus_glib
      xfconf libglade xorg.iceauth
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Session manager for Xfce";
    license = "GPLv2+";
  };
}
