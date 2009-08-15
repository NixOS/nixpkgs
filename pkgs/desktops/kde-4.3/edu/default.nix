{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl,
 facile, ocaml,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeedu-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdeedu-4.2.4.tar.bz2;
    sha1 = "7b26b946e1981ac57efdd2059eb3bba2808aef4b";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile ocaml
                  kdelibs automoc4 phonon ];
}
