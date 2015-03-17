{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  p_name  = "gtk-xfce-engine";
  ver_maj = "2.10";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "4a92910205881f707f2cc8d3c9b00a95feb58eb9084d932c841f3ed027f7063d";
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
