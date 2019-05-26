{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, libxfcegui4, xfconf, gtk, hicolor-icon-theme }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-battery-plugin";
  ver_maj = "1.0";
  ver_min = "5";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "04gbplcj8z4vg5xbks8cc2jjf62mmf9sdymg90scjwmb82pv2ngn";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel libxfcegui4 xfconf gtk hicolor-icon-theme ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Battery plugin for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
