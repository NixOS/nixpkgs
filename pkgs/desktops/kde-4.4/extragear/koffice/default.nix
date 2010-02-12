{ stdenv, fetchurl, lib, cmake, qt4, perl, lcms, exiv2, libxml2, libxslt, boost, glew
, shared_mime_info, poppler, gsl, gmm, wv2, libwpd
, kdelibs, kdepimlibs, automoc4, phonon, qimageblitz, qca2, eigen}:

stdenv.mkDerivation {
  name = "koffice-2.1.0";
  src = fetchurl {
    url = mirror://kde/stable/koffice-2.1.0/koffice-2.1.0.tar.bz2;
    sha256 = "1jdc2rvj5xqd66d152zmjz2psq44kbraqpl0fq05yjg2wz8kdsln";
  }; 
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
