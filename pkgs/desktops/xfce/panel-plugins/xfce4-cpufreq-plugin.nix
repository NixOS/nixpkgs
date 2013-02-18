{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, libxfcegui4, xfconf, gtk}:

stdenv.mkDerivation rec {
  name = "xfce4-cpufreq-plugin-1.0.0";

  src = fetchurl {
    url = "http://archive.xfce.org/src/panel-plugins/xfce4-cpufreq-plugin/1.0/${name}.tar.bz2";
    sha256 = "0q2lj8a25iq9w3dynh6qvsmh19y1v7i82g46yza6gvw7fjcrmcz1";
  };

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf gtk ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/;
    description = "CPU Freq load panel plugin for Xfce";
    platforms = stdenv.lib.platforms.linux;
  };
}
