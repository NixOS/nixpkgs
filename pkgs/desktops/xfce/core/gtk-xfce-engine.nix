{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  p_name  = "gtk-xfce-engine";
  ver_maj = "2.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0rqrnjxx1lzla7wp2fadyixs6jy0js6xh005pgwyqbigpl0v7hy1";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
