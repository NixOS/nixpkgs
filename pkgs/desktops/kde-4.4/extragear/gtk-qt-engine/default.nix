{stdenv, fetchurl, cmake, qt4, perl, libX11, gtk, libbonoboui, gettext, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "gtk-qt-engine-1.1";
  src = fetchurl {
    url = http://gtk-qt-engine.googlecode.com/files/gtk-qt-engine-1.1.tar.bz2;
    sha256 = "4310f8f179c5ab70cea614a07b0c3e84234d05388dded85596200fa754c290a6";
  };
  buildInputs = [ cmake qt4 perl libX11 gtk libbonoboui gettext kdelibs automoc4 phonon ];
  builder = ./builder.sh;
}
