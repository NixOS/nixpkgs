{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdewebdev-4.4.4.tar.bz2;
    sha256 = "1jdc55kvv8kr9s05iyp94cl7n7lsph9flyn499jvzbxd6lq366zi";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
