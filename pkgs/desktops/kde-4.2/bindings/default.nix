{stdenv, fetchurl, cmake, qt4, perl, python, sip, pyqt4,
 kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdebindings-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdebindings-4.2.1.tar.bz2;
    sha1 = "96353bb3269a7ca37ff31487a0fb7a9c25958963";
  };
  builder = ./builder.sh;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl python sip pyqt4
                  kdelibs kdepimlibs automoc4 phonon ];
}
