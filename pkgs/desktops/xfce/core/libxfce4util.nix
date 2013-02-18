{ v, h, stdenv, fetchXfce, pkgconfig, glib, intltool }:

stdenv.mkDerivation rec {
  name = "libxfce4util-${v}";
  src = fetchXfce.core name h;

  buildInputs = [ pkgconfig glib intltool ];

  meta = {
    homepage = http://www.xfce.org/projects/libxfce4;
    description = "Basic utility non-GUI functions for Xfce";
    license = "bsd";
  };
}
