{ stdenv, fetchurl, python, gettext, intltool, pkgconfig, gtk, gvfs }:

stdenv.mkDerivation rec {
  p_name  = "gigolo";
  ver_maj = "0.4";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1y8p9bbv1a4qgbxl4vn6zbag3gb7gl8qj75cmhgrrw9zrvqbbww2";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ python gettext intltool gtk pkgconfig gvfs];

  preConfigure = ''
    sed -i "waf" -e "1 s^.*/env[ ]*python^#!${python}/bin/python^";
  '';

  meta = {
    homepage = "http://goodies.xfce.org/projects/applications/${p_name}";
    description = "A frontend to easily manage connections to remote filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
