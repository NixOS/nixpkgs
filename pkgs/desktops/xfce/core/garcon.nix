{ v, h, stdenv, fetchXfce, pkgconfig, intltool, glib, libxfce4util }:

stdenv.mkDerivation rec {
  name = "garcon-${v}";
  src = fetchXfce.core name h;

  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = "GPLv2+";
  };
}
