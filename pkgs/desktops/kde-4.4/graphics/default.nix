{ stdenv, fetchurl, cmake, lib, perl, qt4, exiv2, lcms, saneBackends, libgphoto2
, libspectre, poppler, djvulibre, chmlib, shared_mime_info, libXxf86vm
, kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdegraphics-4.4.5.tar.bz2;
    sha256 = "1y9ndv0gajhyqiavm4zml6dyn1czrpan03wcn4civkcsgrm3gz8y";
  };
  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends libgphoto2 libspectre poppler chmlib
                  shared_mime_info stdenv.gcc.libc libXxf86vm
                  kdelibs automoc4 phonon strigi qimageblitz soprano qca2
                  djvulibre];
  meta = {
    description = "KDE graphics utilities";
    longDescription = ''
      Contains various graphics utilities such as the Gwenview image viewer and
      Okular a document reader.
    '';
    license = "GPL";
    inherit (kdelibs.meta) maintainers platforms;
  };
}
