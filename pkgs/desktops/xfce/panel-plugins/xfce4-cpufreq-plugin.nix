{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, libxfcegui4, xfconf, gtk, hicolor-icon-theme }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-cpufreq-plugin";
  ver_maj = "1.1";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0crd21l5cw0xgm6w7s049xa36k203yx7l56ssnah9nq1w73n58bl";
  };

  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ libxfce4util libxfce4ui xfce4-panel libxfcegui4 xfconf gtk hicolor-icon-theme ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "CPU Freq load plugin for Xfce panel";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
