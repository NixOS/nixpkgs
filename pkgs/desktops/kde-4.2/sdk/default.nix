{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, subversion,
 kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdesdk-4.2.0.tar.bz2;
    md5 = "79d01b4f10f1ecc283f7860d2c7973e9";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion
                  kdelibs kdepimlibs automoc4 phonon strigi ];
}
