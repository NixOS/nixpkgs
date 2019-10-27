{ stdenv, fetchurl, pkgconfig, intltool, glib, exo, libXtst, xorgproto, libxfce4util, xfce4-panel, libxfce4ui, libxfcegui4, xfconf, gtk, hicolor-icon-theme }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-clipman-plugin";
  ver_maj = "1.2";
  ver_min = "6";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "19a8gwcqc0r5qqi8w28dc8arqip34m8yxdb87lgps9g5qfcky113";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib exo libXtst xorgproto libxfce4util libxfce4ui xfce4-panel libxfcegui4 xfconf gtk hicolor-icon-theme ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Clipboard manager for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
