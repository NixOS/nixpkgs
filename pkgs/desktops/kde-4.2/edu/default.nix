{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl,
 facile, ocaml,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeedu-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdeedu-4.2.0.tar.bz2;
    md5 = "aaddbdab29e1d284ad8ee67a78b4c597";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile
                  kdelibs automoc4 phonon ];
}
