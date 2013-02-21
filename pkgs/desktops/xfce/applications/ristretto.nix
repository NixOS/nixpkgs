{ v, h, stdenv, fetchXfce, pkgconfig, intltool, libexif, gtk
, exo, dbus_glib, libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  name = "ristretto-${v}";
  src = fetchXfce.app name h;

  buildInputs =
    [ pkgconfig intltool libexif gtk dbus_glib exo libxfce4util
      libxfce4ui xfconf
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/ristretto;
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
