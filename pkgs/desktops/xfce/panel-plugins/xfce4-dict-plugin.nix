{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-dict-plugin";
  ver_maj = "0.3";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.gz";
    sha256 = "1x0imfnsdfq7fbhka8bc0yjjspkcljc1jafhrwzb08qi9bk2wbar";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Dictionary plugin for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
    broken = true; # see https://goodies.xfce.org/projects/panel-plugins/xfce4-dict-plugin
  };
}
