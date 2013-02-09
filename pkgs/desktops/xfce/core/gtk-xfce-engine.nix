{ stdenv, fetchXfce, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "gtk-xfce-engine-3.0.1";
  src = fetchXfce.core name "0vd0ly81540f9133abza56mlqqx1swp0j70ll8kf948sva0wy0zb";

  #TODO: gtk3
  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
