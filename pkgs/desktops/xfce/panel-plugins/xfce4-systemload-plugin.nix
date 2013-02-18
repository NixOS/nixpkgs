{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, gtk}:

stdenv.mkDerivation rec {
  name = "xfce4-systemload-plugin-1.1.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/panel-plugins/xfce4-systemload-plugin/1.1/${name}.tar.bz2";
    sha256 = "1bnrr30h6kgb37ixcq7frx2gvj2p99bpa1jyzppwjxp5x7xkxh8s";
  };

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "System load panel plugin for Xfce";
    platforms = stdenv.lib.platforms.linux;
  };
}
