{stdenv, fetchurl, cmake, perl, qt4, kdelibs, pciutils, libraw1394,
 automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdebase-4.2.0.tar.bz2;
    md5 = "da86a8ad624e86eda3a7509f39272060";
  };
  buildInputs = [ cmake perl qt4 kdelibs pciutils libraw1394
                  automoc4 phonon strigi qimageblitz soprano ];
}
