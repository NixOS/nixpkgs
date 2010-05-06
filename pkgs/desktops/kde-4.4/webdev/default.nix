{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdewebdev-4.4.3.tar.bz2;
    sha256 = "1b1ip3b5lb3z2lrs5rslkzhjl942dh3srjxmkwwcfcg6md8h8ph5";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
