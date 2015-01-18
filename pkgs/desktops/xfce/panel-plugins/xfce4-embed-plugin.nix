{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, libxfcegui4, xfconf, gtk}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-embed-plugin";
  ver_maj = "1.4";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0s0zlg7nvjaqvma4l8bhxk171yjrpncsz6v0ff1cxl3z6ya6hbxq";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf gtk ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Embed arbitrary app windows on Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
