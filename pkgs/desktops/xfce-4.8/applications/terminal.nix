{ stdenv, fetchurl
, pkgconfig, ncurses
, intltool, vte
, exo, libxfce4util
, gtk
}:

stdenv.mkDerivation {
  name = "xfce-terminal-0.4.8";

  src = fetchurl {
    url = http://archive.xfce.org/src/apps/xfce4-terminal/0.4/Terminal-0.4.8.tar.bz2;
    sha1 = "2f12c3a0fffad18976d47e531d404ee308cb2f05";
  };

  buildInputs = [ pkgconfig intltool exo gtk vte libxfce4util ncurses ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
