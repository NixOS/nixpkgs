{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, libxfce4ui, xfce4panel
, garcon, gtk, libxklavier, librsvg, libwnck
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-xkb-plugin";
  ver_maj = "0.7";
  ver_min = "1";

  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "10g65j5ia389ahhn3b9hr52ghpp0817fk0m60rfrv4wrzqrjxzk1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4panel garcon
    gtk libxklavier librsvg libwnck  ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Allows you to setup and use multiple keyboard layouts";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
