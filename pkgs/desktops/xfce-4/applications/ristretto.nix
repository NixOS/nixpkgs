{ stdenv, fetchurl, pkgconfig, intltool, libexif, gtk, thunar
, exo, dbus_glib, libxfce4util, libxfcegui4, xfconf }:

stdenv.mkDerivation rec {
  name = "ristretto-0.0.22";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/src/apps/ristretto/0.0/${name}.tar.gz";
    sha1 = "bddbc8618ba67699ccf5ee4ea0b538b1be7fdb0a";
  };

  buildInputs =
    [ pkgconfig intltool libexif gtk thunar exo dbus_glib
      libxfce4util libxfcegui4 xfconf
    ];

  NIX_LDFLAGS = "-lX11";

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/ristretto;
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
