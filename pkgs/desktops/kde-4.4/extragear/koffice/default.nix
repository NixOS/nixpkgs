{ stdenv, fetchurl, lib, cmake, qt4, perl, lcms, exiv2, libxml2, libxslt, boost, glew
, shared_mime_info, poppler, gsl, gmm, wv2, libwpd
, kdelibs, kdepimlibs, automoc4, phonon, qimageblitz, qca2, eigen}:

stdenv.mkDerivation {
  name = "koffice-2.1.1";
  src = fetchurl {
    url = mirror://kde/stable/koffice-2.1.1/koffice-2.1.1.tar.bz2;
    sha256 = "00dcdb68ykcf7yblq68rxh1ldi70irsxzbcgh36aadzgk0k8r4pz";
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
