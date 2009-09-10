{ stdenv, fetchurl, cmake, lib, perl, qt4, exiv2, lcms, saneBackends, libgphoto2
, libspectre, poppler, djvulibre, chmlib, shared_mime_info, libXxf86vm
, kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdegraphics-4.3.1.tar.bz2;
    sha1 = "d57d9007b95607c0ee925cc963d7e14798fc69f9";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends libgphoto2 libspectre poppler chmlib
                  shared_mime_info stdenv.gcc.libc libXxf86vm
                  kdelibs automoc4 phonon strigi qimageblitz soprano qca2 ];
  meta = {
    description = "KDE graphics utilities";
    longDescription = ''
      Contains various graphics utilities such as the Gwenview image viewer and
      Okular a document reader.
    '';
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
