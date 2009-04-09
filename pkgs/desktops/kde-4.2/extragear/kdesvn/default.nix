{stdenv, fetchurl, cmake, qt4, perl, gettext, apr, aprutil, subversion, db4,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdesvn-1.2.4";
  src = fetchurl {
    url = http://kdesvn.alwins-world.de/downloads/kdesvn-1.2.4.tar.bz2;
    sha256 = "aa81addf5f86b4c59026debc555d7aac783002331942847c32d2feb277a81620";
  };
  builder = ./builder.sh;
  inherit subversion;
  buildInputs = [ cmake qt4 perl gettext apr aprutil subversion db4 kdelibs automoc4 phonon ];
}
