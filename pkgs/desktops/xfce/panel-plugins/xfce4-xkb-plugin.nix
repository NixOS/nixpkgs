{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, libxfce4ui, xfce4panel
, gtk, libxklavier, librsvg, libwnck
}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-xkb-plugin";
  ver_maj = "0.5";
  ver_min = "6";

  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "198q6flrajbscwwywqq8yv6hdcwifahhj9i526vyfz4q6cq65r09";
  };

  buildInputs = [ pkgconfig intltool libxfce4util libxfce4ui xfce4panel gtk
    libxklavier librsvg libwnck ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Allows you to setup and use multiple keyboard layouts";
    platforms = stdenv.lib.platforms.linux;
  };
}
