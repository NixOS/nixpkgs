{ stdenv, fetchurl, pkgconfig, intltool, glib, exo, pcre
, libxfce4util, xfce4panel, libxfce4ui, xfconf, gtk }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-verve-plugin";
  ver_maj = "1.0";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1y4vvk3nk1haq39xw0gzscsnnj059am1p3acgq9mj0miyiz8971v";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool glib exo pcre libxfce4util libxfce4ui xfce4panel xfconf gtk ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "A command-line plugin";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
