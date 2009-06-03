{stdenv, fetchurl, cmake, perl, qt4, exiv2, lcms, saneBackends, libgphoto2,
 libspectre, poppler, djvulibre, chmlib, libXxf86vm,
 kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdegraphics-4.2.3.tar.bz2;
    sha1 = "1304fe7562e41fad30841dfda4b42197e3d95b3d";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends libgphoto2 libspectre poppler chmlib
                  stdenv.gcc.libc libXxf86vm
                  kdelibs automoc4 phonon strigi qimageblitz soprano qca2 ];
}
