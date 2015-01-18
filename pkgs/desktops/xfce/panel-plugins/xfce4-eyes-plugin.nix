{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, libxfcegui4, xfconf, gtk}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-eyes-plugin";
  ver_maj = "4.4";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0z4161i14m73i515ymhj34c1ycz5fmjmbczdd8plx3nvrxdk76jb";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf gtk ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Eyes following you!";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
