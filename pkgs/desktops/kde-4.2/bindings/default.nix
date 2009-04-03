{stdenv, fetchurl, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4,
 libSM, libXrender, libXrandr, libXfixes, libXinerama, libXcursor, libXext, kdelibs}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation {
  name = "kdebindings-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdebindings-4.2.2.tar.bz2;
    sha1 = "1d5eb1bb92f68172d0a0345070b1120c2601ab8c";
  };
  builder = ./builder.sh;
  buildInputs = [ python sip pyqt4 zlib libpng freetype fontconfig qt4
                  libSM libXrender libXrandr libXfixes libXcursor libXinerama libXext kdelibs ];
}
