{ stdenv, fetchurl, pkgconfig, intltool, glib, exo, pcre
, libxfce4util, xfce4panel, libxfce4ui, libxfcegui4, xfconf, gtk}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-verve-plugin";
  ver_maj = "1.0";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "18zi8lam82xwjm5zdnilg3ffxpp5z8vjad3kjvdsyxdhsdza84fh";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool glib exo pcre libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf gtk ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "A command-line plugin";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
