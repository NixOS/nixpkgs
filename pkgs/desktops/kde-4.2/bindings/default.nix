{stdenv, fetchurl, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4,
 libSM, libXrender, libXrandr, libXfixes, libXinerama, libXcursor, libXext, kdelibs}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation {
  name = "kdebindings-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdebindings-4.2.4.tar.bz2;
    sha1 = "5550b690d1c63fc63b3603ad73ba2b911158fe96";
  };
  builder = ./builder.sh;
  includeAllQtDirs=true;
  buildInputs = [ python sip pyqt4 zlib libpng freetype fontconfig qt4
                  libSM libXrender libXrandr libXfixes libXcursor libXinerama libXext kdelibs ];
}
