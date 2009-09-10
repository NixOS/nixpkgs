{ stdenv, fetchurl, lib, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4
, libSM, libXrender, libXrandr, libXfixes, libXinerama, libXcursor, libXext, kdelibs}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation {
  name = "kdebindings-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdebindings-4.3.1.tar.bz2;
    sha1 = "bb414b1ab28b51d9bbbfaa2d9c8474b27c325c32";
  };
  builder = ./builder.sh;
  includeAllQtDirs=true;
  buildInputs = [ python sip pyqt4 zlib libpng freetype fontconfig qt4
                  libSM libXrender libXrandr libXfixes libXcursor libXinerama libXext kdelibs ];
  meta = {
    description = "KDE bindings";
    longDescription = "Provides KDE bindings for several languages such as Java, Smoke and Python";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
