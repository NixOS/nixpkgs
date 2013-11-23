{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, libxfcegui4, xfce4panel
, gtk }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-datetime-plugin";
  ver_maj = "0.6";
  ver_min = "1";

  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "06xvh22y5y0bcy7zb9ylvjpcl09wdyb751r7gwyg7m3h44f0qd7v";
  };

  buildInputs = [ pkgconfig intltool libxfce4util libxfcegui4 xfce4panel gtk ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Shows the date and time in the panel, and a calendar appears when you left-click on it";
    platforms = stdenv.lib.platforms.linux;
  };
}
