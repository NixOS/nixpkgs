{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, libxfcegui4, xfconf, gtk}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-cpufreq-plugin";
  ver_maj = "1.0";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0q2lj8a25iq9w3dynh6qvsmh19y1v7i82g46yza6gvw7fjcrmcz1";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf gtk ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "CPU Freq load plugin for Xfce panel";
    platforms = stdenv.lib.platforms.linux;
  };
}
