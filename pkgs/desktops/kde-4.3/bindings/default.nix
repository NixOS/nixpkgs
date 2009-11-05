{ stdenv, fetchurl, lib, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4
, libSM, libXrender, libXrandr, libXfixes, libXinerama, libXcursor, libXext, kdelibs}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation {
  name = "kdebindings-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdebindings-4.3.3.tar.bz2;
    sha1 = "8101wqhahlmrrpdr4f32p5iqsgawzp9l";
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
