{ stdenv, fetchurl, intltool, pkgconfig, gtk, libwnck }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-taskmanager";
  ver_maj = "1.0";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "11pfiglfg3mzsmpiwva6l7dj44zsv76vyf0282pghwcrvnb2gapm";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ intltool pkgconfig gtk libwnck ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/applications/${p_name}";
    description = "Easy to use task manager for Xfce";
    platforms = stdenv.lib.platforms.linux;
  };
}
