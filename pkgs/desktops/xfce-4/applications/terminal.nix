{ stdenv, fetchurl
, pkgconfig, ncurses
, intltool, vte
, exo, libxfce4util
, gtk
}:

stdenv.mkDerivation {
  name = "xfce-terminal-0.4.5";
  
  src = fetchurl {
    url = http://archive.xfce.org/src/apps/terminal/0.4/Terminal-0.4.5.tar.bz2;
    sha256 = "14w8mhmyrq6dd9574zfvq0pymknljckq6qgcv1r6c1r22jydrzcj";
  };

  buildInputs = [ pkgconfig intltool exo gtk vte libxfce4util ncurses ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
