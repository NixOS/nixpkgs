{stdenv, fetchurl, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4,
 libSM, libXrender, libXrandr, libXfixes, libXinerama, libXcursor, libXext, kdelibs}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation {
  name = "kdebindings-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdebindings-4.2.1.tar.bz2;
    sha1 = "96353bb3269a7ca37ff31487a0fb7a9c25958963";
  };
  builder = ./builder.sh;
  buildInputs = [ python sip pyqt4 zlib libpng freetype fontconfig qt4
                  libSM libXrender libXrandr libXfixes libXcursor libXinerama libXext kdelibs ];
}
