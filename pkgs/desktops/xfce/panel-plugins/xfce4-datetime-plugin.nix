{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, libxfcegui4, xfce4panel
, gtk }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-datetime-plugin";
  ver_maj = "0.6";
  ver_min = "2";

  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0b4yril07qgkmywjym1qp12r4g35bnh96879zbjps7cd3rkxld4p";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfcegui4 xfce4panel gtk ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Shows the date and time in the panel, and a calendar appears when you left-click on it";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
