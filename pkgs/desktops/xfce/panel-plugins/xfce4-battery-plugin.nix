{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, libxfcegui4, xfconf, gtk}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-battery-plugin";
  ver_maj = "1.0";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "07qji9gh7ail06kwf1lniph5fdccvrsjwsxwnlbw0cmrws0bb2y2";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf gtk ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Battery plugin for Xfce panel";
    platforms = stdenv.lib.platforms.linux;
  };
}
