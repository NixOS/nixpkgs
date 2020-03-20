{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-eyes-plugin";
  ver_maj = "4.4";
  ver_min = "4";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1jh02hylvsvfpxrx0bq6fzgy6vnxf9qakgpbfvr63lfkd1dyh314";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 ];

  meta = {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Eyes following you!";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
    broken = true;
  };
}
