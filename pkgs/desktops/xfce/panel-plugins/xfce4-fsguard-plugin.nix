{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel, libxfce4ui, libxfcegui4, xfconf, gtk}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-fsguard-plugin";
  ver_maj = "1.0";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1dxa6gpw4a07ixccafd9fnk38r4fax4bhll73fchpv39jzh7xyzz";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel libxfcegui4 xfconf gtk ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Filesystem monitor";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
