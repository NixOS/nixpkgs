{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, gtk}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-systemload-plugin";
  ver_maj = "1.1";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1bnrr30h6kgb37ixcq7frx2gvj2p99bpa1jyzppwjxp5x7xkxh8s";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel gtk ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "System load plugin for Xfce panel";
    platforms = stdenv.lib.platforms.linux;
  };
}
