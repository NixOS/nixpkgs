{ stdenv, fetchurl, lib, cmake, qt4, perl, lcms, exiv2, libxml2, libxslt, boost, glew
, shared_mime_info, poppler, gsl, gmm, wv2, libwpd
, kdelibs, kdepimlibs, automoc4, phonon, qimageblitz, qca2, eigen}:

stdenv.mkDerivation {
  name = "koffice-2.0.2";
  src = fetchurl {
    url = mirror://kde/stable/koffice-2.0.2/src/koffice-2.0.2.tar.bz2;
    sha256 = "1nvpj8viw7ijjnz1pg6kdb21srsm13vh6c1v7s01hn4xrv9zwyic";
  }; 
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl lcms exiv2 libxml2 libxslt boost glew shared_mime_info 
                  poppler gsl gmm wv2 libwpd
                  kdelibs kdepimlibs automoc4 phonon qimageblitz qca2 eigen ];
  meta = {
    description = "KDE integrated Office Suite";
    license = "GPL";
    homepage = http://www.koffice.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
