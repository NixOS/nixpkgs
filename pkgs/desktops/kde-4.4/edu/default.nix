{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, xplanet, libspectre
, kdelibs, automoc4, phonon, eigen, attica}:

stdenv.mkDerivation {
  name = "kdeedu-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdeedu-4.4.5.tar.bz2;
    sha256 = "1n5r50w6510jr2l7faxkbz684bj1aw7s2arxqvasfs51hn2jl9qk";
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
