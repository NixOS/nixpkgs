{stdenv, fetchurl, cmake, perl, qt4, kdelibs, pciutils, libraw1394,
 automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdebase-4.2.4.tar.bz2;
    sha1 = "c08188baa90a5075f18a75640c4dc3e6dc69daa0";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 kdelibs pciutils stdenv.gcc.libc libraw1394
                  automoc4 phonon strigi qimageblitz soprano ];
}
