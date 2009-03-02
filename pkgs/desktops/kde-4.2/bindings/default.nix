{stdenv, fetchurl, cmake, qt4, perl, python, sip, pyqt4,
 kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdebindings-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdebindings-4.2.0.tar.bz2;
    md5 = "6eae8fd968da83fe65e592993e416adc";
  };
  builder = ./builder.sh;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl python sip pyqt4
                  kdelibs kdepimlibs automoc4 phonon ];
}
