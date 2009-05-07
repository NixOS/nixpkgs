{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl,
 facile, ocaml,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeedu-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdeedu-4.2.3.tar.bz2;
    sha1 = "32a3ddef04f3e0d7d110f616caf98c4537ee8bb8";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile ocaml
                  kdelibs automoc4 phonon ];
}
