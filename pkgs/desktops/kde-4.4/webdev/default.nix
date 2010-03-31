{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdewebdev-4.4.2.tar.bz2;
    sha256 = "0rc1xbs6daczpxryhch5gqwl95amk1qz9r72k46dv86pbbd9qvl5";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
