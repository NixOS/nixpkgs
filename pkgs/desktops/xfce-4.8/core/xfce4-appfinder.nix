{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk, libxfce4util
, libxfce4ui, garcon, xfconf }:

stdenv.mkDerivation rec {
  name = "xfce4-appfinder-4.8.0";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce4-appfinder/4.8/${name}.tar.bz2";
    sha1 = "444bbcbded8d2346f9b9beb57ec7adaf556811c9";
  };

  buildInputs =
    [ pkgconfig intltool glib gtk libxfce4util libxfce4ui garcon xfconf ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce application finder, a tool to locate and launch programs on your system";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
