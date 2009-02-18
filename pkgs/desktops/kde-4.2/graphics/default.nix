{stdenv, fetchurl, cmake, perl, qt4, exiv2, lcms, saneBackends, gphoto2,
 libspectre, poppler, djvulibre, chmlib, libXxf86vm,
 kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdegraphics-4.2.0.tar.bz2;
    md5 = "8beb6fe5d475d0b0245ea6d4cc7e9732";
  };
  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends gphoto2 libspectre poppler chmlib
                  stdenv.gcc.libc libXxf86vm
                  kdelibs automoc4 phonon strigi qimageblitz soprano qca2 ];
}
