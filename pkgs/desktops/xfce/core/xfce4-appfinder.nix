{ v, h, stdenv, fetchXfce, pkgconfig, intltool, glib, gtk, libxfce4util
, libxfce4ui, garcon, xfconf }:

stdenv.mkDerivation rec {
  name = "xfce4-appfinder-${v}";
  src = fetchXfce.core name h;

  buildInputs =
    [ pkgconfig intltool glib gtk libxfce4util libxfce4ui garcon xfconf ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://docs.xfce.org/xfce/xfce4-appfinder/;
    description = "Xfce application finder, a tool to locate and launch programs on your system";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
