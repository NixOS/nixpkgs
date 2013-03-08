{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk, libxfce4util
, libxfce4ui, garcon, xfconf }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-appfinder";
  ver_maj = "4.9"; # no 4.10 (stable) release yet
  ver_min = "4";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "12lgrbd1n50w9n8xkpai98s2aw8vmjasrgypc57sp0x0qafsqaxq";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

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
