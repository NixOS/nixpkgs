{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, facile, ocaml, xplanet
, kdelibs, automoc4, phonon, eigen}:

stdenv.mkDerivation {
  name = "kdeedu-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdeedu-4.3.1.tar.bz2;
    sha1 = "6326cff7779dfadc1b18a3a6bbe7b0750fb7ceaf";
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
