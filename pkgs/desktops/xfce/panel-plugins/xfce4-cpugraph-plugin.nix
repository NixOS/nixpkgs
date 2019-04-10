{ stdenv, fetchurl, pkgconfig, intltool, glib, exo, libXtst, xorgproto, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk, hicolor-icon-theme }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-cpugraph-plugin";
  ver_maj = "1.0";
  ver_min = "5";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1izl53q95m5xm2fiq7385vb1i9nwgjizxkmgpgh33zdckb40xnl5";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib exo libXtst xorgproto libxfce4util libxfce4ui xfce4-panel xfconf gtk hicolor-icon-theme ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "CPU graph show for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
