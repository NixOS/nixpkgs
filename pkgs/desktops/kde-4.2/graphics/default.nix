{stdenv, fetchurl, cmake, perl, qt4, exiv2, lcms, saneBackends, libgphoto2,
 libspectre, poppler, djvulibre, chmlib, libXxf86vm,
 kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdegraphics-4.2.1.tar.bz2;
    sha1 = "5c21e016c75a79a9499aac26ea1240d6024e700e";
  };
  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends libgphoto2 libspectre poppler chmlib
                  stdenv.gcc.libc libXxf86vm
                  kdelibs automoc4 phonon strigi qimageblitz soprano qca2 ];
}
