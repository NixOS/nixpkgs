{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, xplanet, libspectre
, kdelibs, automoc4, phonon, eigen, attica}:

stdenv.mkDerivation {
  name = "kdeedu-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdeedu-4.4.2.tar.bz2;
    sha256 = "0fgqsizp1vm0yp6nirbqbxj0kvbqvnb8q3wxzav4hhn85r294ps7";
  };
#TODO: facile, indi, boost.python, cfitsio, R, qalculate
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl xplanet
                  kdelibs automoc4 phonon eigen attica libspectre ];
  meta = {
    description = "KDE Educative software";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
