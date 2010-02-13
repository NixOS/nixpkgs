{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, facile, ocaml, xplanet
, kdelibs, automoc4, phonon, eigen, attica}:

stdenv.mkDerivation {
  name = "kdeedu-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdeedu-4.4.0.tar.bz2;
    sha256 = "0qc7y361ndpmvjpkdxa7psvx9brx3lhwp5fmm94j6gva7kvyad9d";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile ocaml xplanet
                  kdelibs automoc4 phonon eigen attica ];
  meta = {
    description = "KDE Educative software";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
