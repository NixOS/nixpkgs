{ stdenv, fetchurl, python, gettext, intltool, pkgconfig, gtk, gvfs}:

stdenv.mkDerivation rec {
  name = "gigolo-0.4.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/gigolo/0.4/${name}.tar.bz2";
    sha256 = "1y8p9bbv1a4qgbxl4vn6zbag3gb7gl8qj75cmhgrrw9zrvqbbww2";
  };

  buildInputs = [ python gettext intltool gtk pkgconfig gvfs];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/gigolo;
    description = "Gigolo is a frontend to easily manage connections to remote filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}