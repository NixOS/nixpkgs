{ stdenv, fetchurl, pkgconfig, intltool, gtk, gtk3 }:

stdenv.mkDerivation rec {
  p_name  = "gtk-xfce-engine";
  ver_maj = "3.0";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0vd0ly81540f9133abza56mlqqx1swp0j70ll8kf948sva0wy0zb";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  #TODO: gtk3
  buildInputs = [ pkgconfig intltool gtk gtk3 ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
