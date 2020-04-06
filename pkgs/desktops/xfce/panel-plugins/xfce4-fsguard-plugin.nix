{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-fsguard-plugin";
  ver_maj = "1.0";
  ver_min = "2";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1bj021h4q68bc03f32pkyqy4gfd1sz6s21nxdg7j6gdfhs9xbj52";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 ];

  meta = {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Filesystem monitor";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
    broken = true;
  };
}
