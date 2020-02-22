{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-genmon-plugin";
  ver_maj = "3.4";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "11q3g6lmgz3d5lyh6614mxkd9cblfdyf9jgki7f26mn895xk79dh";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Cyclically spawns a command and captures its output";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
    broken = true;
  };
}
