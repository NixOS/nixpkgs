{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, facile, ocaml, xplanet
, kdelibs, automoc4, phonon, eigen}:

stdenv.mkDerivation {
  name = "kdeedu-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/kdeedu-4.3.2.tar.bz2;
    sha1 = "6mbvpkrd8p7d58f5xjzys79b4h44y9yz";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm gsl facile ocaml xplanet
                  kdelibs automoc4 phonon eigen ];
  meta = {
    description = "KDE Educative software";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
