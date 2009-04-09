{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl,
 facile, ocaml,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeedu-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdeedu-4.2.2.tar.bz2;
    sha1 = "c6aaf3639188e66d14da0d404a9b5d5fb95e7df5";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile ocaml
                  kdelibs automoc4 phonon ];
}
