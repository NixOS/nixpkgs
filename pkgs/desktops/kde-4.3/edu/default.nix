{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, facile, ocaml, xplanet
, kdelibs, automoc4, phonon, eigen}:

stdenv.mkDerivation {
  name = "kdeedu-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdeedu-4.3.5.tar.bz2;
    sha256 = "0740wsakzl5aa50d02lank8mdhgrs9fllfd3ykhwd66lasxx55a4";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile ocaml xplanet
                  kdelibs automoc4 phonon eigen ];
  meta = {
    description = "KDE Educative software";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
