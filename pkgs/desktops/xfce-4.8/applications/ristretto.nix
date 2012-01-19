{ stdenv, fetchurl, pkgconfig, intltool, libexif, gtk, thunar
, exo, dbus_glib, libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  name = "ristretto-0.2.3";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/ristretto/0.2/${name}.tar.bz2";
    sha1 = "5a34b865cb9013b67467b0e8d51970f0a1e977d1";
  };

  buildInputs =
    [ pkgconfig intltool libexif gtk dbus_glib libxfce4util
      libxfce4ui xfconf
    ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/ristretto;
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
