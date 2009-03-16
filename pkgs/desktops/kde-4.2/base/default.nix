{stdenv, fetchurl, cmake, perl, qt4, kdelibs, pciutils, libraw1394,
 automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdebase-4.2.1.tar.bz2;
    sha1 = "c500024294a7621d176d26bdabdd138d18ec827d";
  };
  buildInputs = [ cmake perl qt4 kdelibs pciutils stdenv.gcc.libc libraw1394
                  automoc4 phonon strigi qimageblitz soprano ];
}
