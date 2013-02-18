{ v, h, stdenv, fetchXfce, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "xfce4-icon-theme-${v}";
  src = fetchXfce.art name h;

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Icons for Xfce";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
