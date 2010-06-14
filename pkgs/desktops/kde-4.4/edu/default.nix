{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, xplanet, libspectre
, kdelibs, automoc4, phonon, eigen, attica}:

stdenv.mkDerivation {
  name = "kdeedu-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdeedu-4.4.4.tar.bz2;
    sha256 = "0rdpay0xs5j0k5r2m5yxm89ls5x7rzj9k758axz22r6wv1xynvz0";
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
