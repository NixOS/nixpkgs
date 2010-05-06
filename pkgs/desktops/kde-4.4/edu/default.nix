{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, xplanet, libspectre
, kdelibs, automoc4, phonon, eigen, attica}:

stdenv.mkDerivation {
  name = "kdeedu-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdeedu-4.4.3.tar.bz2;
    sha256 = "17hb1j7dy5ccgmna26cabng0z48qdhl8z0w2grm83a1a9szq2y4x";
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
