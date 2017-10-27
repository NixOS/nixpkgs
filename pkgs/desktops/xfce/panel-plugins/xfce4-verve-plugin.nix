{ stdenv, fetchurl, pkgconfig, intltool, glib, exo, pcre
, libxfce4util, xfce4panel, libxfce4ui, xfconf, gtk }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-verve-plugin";
  ver_maj = "1.1";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "114wkmgjxkim1jkswih20zg9d7rbzmlf30b5rlcpvmbsij0ny6d3";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib exo pcre libxfce4util libxfce4ui xfce4panel xfconf gtk ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "A command-line plugin";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
