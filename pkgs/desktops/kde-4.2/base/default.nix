{stdenv, fetchurl, cmake, perl, qt4, kdelibs, pciutils, libraw1394,
 automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdebase-4.2.2.tar.bz2;
    sha1 = "10309413767b856d303102155911518519e5b57e";
  };
  buildInputs = [ cmake perl qt4 kdelibs pciutils stdenv.gcc.libc libraw1394
                  automoc4 phonon strigi qimageblitz soprano ];
}
