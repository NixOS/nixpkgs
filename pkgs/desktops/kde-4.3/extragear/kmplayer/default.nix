{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, pango, gtk, dbus_glib, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kmplayer-0.11.1b";
  src = fetchurl {
    url = http://kmplayer.kde.org/pkgs/kmplayer-0.11.1b.tar.bz2;
    sha256 = "04wzxxa83kxfzpsrllbdgl0kd6jj13kzhdkm2w66s7mpylr88lfi";
  };
  includeAllQtDirs=true;
  builder = ./builder.sh;
  buildInputs = [ cmake qt4 perl gettext stdenv.gcc.libc pango gtk dbus_glib kdelibs automoc4 phonon ];
  meta = {
    description = "MPlayer front-end for KDE";
    license = "GPL";
    homepage = http://kmplayer.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
