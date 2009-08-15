{stdenv, fetchurl, cmake, perl, qt4, exiv2, lcms, saneBackends, libgphoto2,
 libspectre, poppler, djvulibre, chmlib, libXxf86vm,
 kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdegraphics-4.2.4.tar.bz2;
    sha1 = "032352e87be16ae90f09183a466e61487ef1e738";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends libgphoto2 libspectre poppler chmlib
                  stdenv.gcc.libc libXxf86vm
                  kdelibs automoc4 phonon strigi qimageblitz soprano qca2 ];
}
