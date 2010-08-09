{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfcegui4
, libglade, xfconf, xorg, libwnck, libnotify }:

stdenv.mkDerivation rec {
  name = "xfce4-settings-4.6.5";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha1 = "c036cc2f3100a46b2649e678dff7c0106b219263";
  };

  buildInputs =
    [ pkgconfig intltool exo gtk libxfce4util libxfcegui4 libglade
      xfconf xorg.libXi xorg.libXcursor libwnck libnotify
    #gtk libxfce4util libxfcegui4 libwnck dbus_glib
      #xfconf libglade xorg.iceauth
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Settings manager for Xfce";
    license = "GPLv2+";
  };
}
