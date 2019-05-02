{ stdenv, fetchurl, intltool, pkgconfig, gtk, libwnck }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-taskmanager";
  ver_maj = "1.1";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1jwywmkkkmz7406m1jq40w6apiav25cznafhigbgpjv6z5hv27if";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gtk libwnck ];

  meta = {
    homepage = "https://goodies.xfce.org/projects/applications/${p_name}";
    description = "Easy to use task manager for Xfce";
    platforms = stdenv.lib.platforms.linux;
  };
}
