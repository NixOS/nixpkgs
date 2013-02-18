{ stdenv, v, h, fetchXfce, intltool, pkgconfig, gtk, libwnck }:

stdenv.mkDerivation rec {
  name = "xfce4-taskmanager-${v}";
  src = fetchXfce.app name h;

  buildInputs = [ intltool pkgconfig gtk libwnck ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-taskmanager;
    description = "Easy to use task manager for XFCE";
    platforms = stdenv.lib.platforms.linux;
  };
}
