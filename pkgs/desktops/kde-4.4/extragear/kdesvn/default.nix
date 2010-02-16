{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, apr, aprutil, subversion, db4
, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdesvn-1.5.2";
  src = fetchurl {
    url = http://kdesvn.alwins-world.de/downloads/kdesvn-1.5.2.tar.bz2;
    sha256 = "1svblxi70ks816zj1w4cc87x72b628g7xjx4hvx57zw8d9hr463h";
  };
  builder = ./builder.sh;
  inherit subversion;
  buildInputs = [ cmake qt4 perl gettext apr aprutil subversion db4 kdelibs automoc4 phonon ];
  meta = {
    description = "KDE SVN front-end";
    license = "GPL";
    homepage = http://kdesvn.alwins-world.de;
    maintainers = [ lib.maintainers.sander ];
  };
}
