{ stdenv, fetchurl, cmake, qt4, perl, lcms, exiv2, libxml2, libxslt, boost, glew
, shared_mime_info, poppler, gsl, gmm, wv2, libwpd
, kdelibs, kdepimlibs, automoc4, phonon, qimageblitz, qca2, eigen}:

stdenv.mkDerivation {
  name = "koffice-2.0.0";
  src = fetchurl {
    url = mirror://kde/stable/koffice-2.0.0/src/koffice-2.0.0.tar.bz2;
    sha256 = "8cfc35acf4b6d306245e7705899167fd1b67a861136551ab02a0cd7542eb72e9";
  }; 
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl lcms exiv2 libxml2 libxslt boost glew shared_mime_info 
                  poppler gsl gmm wv2 libwpd
                  kdelibs kdepimlibs automoc4 phonon qimageblitz qca2 eigen ];
}
