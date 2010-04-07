{ stdenv, fetchurl, lib, cmake, qt4, perl, lcms, exiv2, libxml2, libxslt, boost, glew
, shared_mime_info, poppler, gsl, gmm, wv2, libwpd
, kdelibs, kdepimlibs, automoc4, phonon, qimageblitz, qca2, eigen}:

stdenv.mkDerivation {
  name = "koffice-2.1.2";
  src = fetchurl {
    url = mirror://kde/stable/koffice-2.1.2/koffice-2.1.2.tar.bz2;
    sha256 = "1nmp2kmksk6vjw9bk04lnl8ld43hf4s0ras6vali725innvkn8v4";
  }; 
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
