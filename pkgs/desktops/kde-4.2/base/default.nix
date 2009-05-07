{stdenv, fetchurl, cmake, perl, qt4, kdelibs, pciutils, libraw1394,
 automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdebase-4.2.3.tar.bz2;
    sha1 = "bc05bf836ff2aea64c0806be161b8ec8b9a5a42b";
  };
  buildInputs = [ cmake perl qt4 kdelibs pciutils stdenv.gcc.libc libraw1394
                  automoc4 phonon strigi qimageblitz soprano ];
}
