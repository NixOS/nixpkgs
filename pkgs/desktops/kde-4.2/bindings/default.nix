{stdenv, fetchurl, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4,
 libSM, libXrender, libXrandr, libXfixes, libXinerama, libXcursor, libXext, kdelibs}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation {
  name = "kdebindings-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdebindings-4.2.3.tar.bz2;
    sha1 = "d8e5ddf5e993124e0250c3e9a9de52264ca5ca7c";
  };
  builder = ./builder.sh;
  buildInputs = [ python sip pyqt4 zlib libpng freetype fontconfig qt4
                  libSM libXrender libXrandr libXfixes libXcursor libXinerama libXext kdelibs ];
}
