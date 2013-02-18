{ h, v, stdenv, fetchXfce, python, gettext, intltool, pkgconfig, gtk, gvfs }:

stdenv.mkDerivation rec {
  name = "gigolo-${v}";

  src = fetchXfce.app name h;

  buildInputs = [ python gettext intltool gtk pkgconfig gvfs];

  preConfigure = ''
    sed -i "waf" -e "1 s^.*/env[ ]*python^#!${python}/bin/python^";
  '';

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/gigolo;
    description = "A frontend to easily manage connections to remote filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
