{stdenv, fetchurl, cmake, perl, bzip2, qt4, alsaLib, xineLib, samba, kdelibs,
 automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdebase-runtime-4.2.0.tar.bz2;
    md5 = "8ef48aae16a6dddb3055d81d7e5c375f";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  buildInputs = [ cmake perl bzip2 qt4 alsaLib xineLib samba stdenv.gcc.libc kdelibs
                  automoc4 phonon strigi soprano cluceneCore ];
}
