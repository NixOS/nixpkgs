{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, libxfcegui4, xfconf, gtk, hicolor-icon-theme }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-netload-plugin";
  ver_maj = "1.2";
  ver_min = "4";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1lrhhzxmybcfl52hnadr2dvasis9wmk6a48pcy02s09ch8cfkb7z";
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
