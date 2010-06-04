{ stdenv, fetchurl, cmake, lib, perl, qt4, exiv2, lcms, saneBackends, libgphoto2
, libspectre, poppler, djvulibre, chmlib, shared_mime_info, libXxf86vm
, kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdegraphics-4.4.4.tar.bz2;
    sha256 = "1czrasc3ppk4waxsv4mcps25lbdvdspwgnsnad32b0qq0dls3mn1";
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
    maintainers = [ lib.maintainers.sander ];
  };
}
