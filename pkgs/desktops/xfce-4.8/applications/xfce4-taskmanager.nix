{ stdenv, fetchurl, intltool, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  name = "xfce4-taskmanager-1.0.0";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/xfce4-taskmanager/1.0/${name}.tar.bz2";
    sha256 = "1vm9gw7j4ngjlpdhnwdf7ifx6xrrn21011almx2vwidhk2f9zvy0";
  };

  buildInputs = [ intltool pkgconfig gtk ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-taskmanager;
    description = "Easy to use task manager for XFCE";
    platforms = stdenv.lib.platforms.linux;
  };
}