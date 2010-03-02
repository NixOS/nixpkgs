{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.4.1";
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdewebdev-4.4.1.tar.bz2;
    sha256 = "1c7dqvnd0q4n1ci128iqf83b7hvcz9n0m3djkdcid3q8b0maish0";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
