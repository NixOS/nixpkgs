{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk, libxfce4util
, libxfce4ui, garcon, xfconf }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-appfinder";
  ver_maj = "4.10";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0xzbi1vvy724s7vljf4153h7s7zqqwg51bn9wirx4d33lzzp9vk5";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool glib gtk libxfce4util libxfce4ui garcon xfconf ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://docs.xfce.org/xfce/xfce4-appfinder/;
    description = "Xfce application finder, a tool to locate and launch programs on your system";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
