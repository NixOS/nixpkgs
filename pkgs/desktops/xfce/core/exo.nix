{ v, h, stdenv, fetchXfce, pkgconfig, intltool, URI, glib, gtk, libxfce4ui, libxfce4util }:

stdenv.mkDerivation rec {
  name = "exo-${v}";
  src = fetchXfce.core name h;

  buildInputs = [ pkgconfig intltool URI glib gtk libxfce4ui libxfce4util ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/projects/exo;
    description = "Application library for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
