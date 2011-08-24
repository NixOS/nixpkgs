{ stdenv, fetchurl, pkgconfig, intltool, libexif, gtk, thunar
, exo, dbus_glib, libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  name = "ristretto-0.0.93";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/ristretto/0.0/${name}.tar.bz2";
    sha1 = "c71acaad169633faffe26609f9cc671b04ff52d3";
  };

  buildInputs =
    [ pkgconfig intltool libexif gtk thunar exo dbus_glib
      libxfce4util libxfce4ui xfconf
    ];

  NIX_LDFLAGS = "-lX11";

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/ristretto;
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
