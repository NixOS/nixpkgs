{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl,
 facile, ocaml,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeedu-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdeedu-4.2.1.tar.bz2;
    sha1 = "f2381f33f6586b950e925423d135b9e66b7bf428";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile ocaml
                  kdelibs automoc4 phonon ];
}
