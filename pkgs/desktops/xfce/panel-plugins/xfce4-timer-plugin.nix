{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel
, libxfce4ui, libxfcegui4, xfconf, gtk, hicolor-icon-theme }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-timer-plugin";
  ver_maj = "1.6";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0z46gyw3ihcd1jf0m5z1dsc790xv1cpi8mk1dagj3i4v14gx5mrr";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ intltool libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf
    gtk hicolor-icon-theme ];

  nativeBuildInputs = [ pkgconfig ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Battery plugin for Xfce panel";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
