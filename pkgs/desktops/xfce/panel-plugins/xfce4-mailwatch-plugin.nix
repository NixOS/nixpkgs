{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui,
libxfcegui4, xfconf, gtk, exo, gnutls, libgcrypt }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-mailwatch-plugin";
  ver_maj = "1.2";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1bfw3smwivr9mzdyq768biqrl4aq94zqi3xjzq6kqnd8561cqjk2";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel
    libxfcegui4 xfconf gtk exo gnutls libgcrypt ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Mailwatch plugin for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
