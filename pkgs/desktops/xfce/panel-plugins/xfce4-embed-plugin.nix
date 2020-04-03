{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2 }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-embed-plugin";
  ver_maj = "1.6";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0a72kqsjjh45swimqlpyrahdnplp0383v0i4phr4n6g8c1ixyry7";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 ];

  meta = {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Embed arbitrary app windows on Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
