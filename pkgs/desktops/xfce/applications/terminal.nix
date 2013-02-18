{ v, h, stdenv, fetchXfce, pkgconfig, intltool, ncurses, gtk, vte, dbus_glib
, exo, libxfce4util, libxfce4ui
}:

stdenv.mkDerivation rec {
  name = "xfce4-terminal-${v}";
  src = fetchXfce.app name h;

  buildInputs = [ pkgconfig intltool exo gtk vte libxfce4util ncurses dbus_glib libxfce4ui ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
