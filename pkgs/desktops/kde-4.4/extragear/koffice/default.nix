{ stdenv, fetchurl, lib, cmake, qt4, perl, lcms, exiv2, libxml2, libxslt, boost, glew
, shared_mime_info, poppler, gsl, gmm, wv2, libwpd, giflib, libgsf
, kdelibs, kdepimlibs, automoc4, phonon, qimageblitz, qca2, eigen, soprano}:

stdenv.mkDerivation {
  name = "koffice-2.2.0";
  src = fetchurl {
    url = mirror://kde/stable/koffice-2.2.0/koffice-2.2.0.tar.bz2;
    sha256 = "0qa73grmn4c2d7zs5p0sxg6dws8hpg8v2vgp6frhj55l0sk3kqba";
  }; 
  buildInputs = [ cmake qt4 perl lcms exiv2 libxml2 libxslt boost glew shared_mime_info 
                  poppler gsl gmm wv2 libwpd giflib libgsf stdenv.gcc.libc
                  kdelibs kdepimlibs automoc4 phonon qimageblitz qca2 eigen soprano ];
  meta = {
    description = "KDE integrated Office Suite";
    license = "GPL";
    homepage = http://www.koffice.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
