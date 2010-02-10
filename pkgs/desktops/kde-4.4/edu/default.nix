{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, facile, ocaml, xplanet
, kdelibs, automoc4, phonon, eigen}:

stdenv.mkDerivation {
  name = "kdeedu-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdeedu-4.3.4.tar.bz2;
    sha1 = "ee646d57db11b761d8da33fc03c596c8f531eb9d";
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
