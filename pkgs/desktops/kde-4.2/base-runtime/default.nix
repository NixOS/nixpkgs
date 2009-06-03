{stdenv, fetchurl, cmake, perl, bzip2, qt4, alsaLib, xineLib, samba, kdelibs,
 automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdebase-runtime-4.2.3.tar.bz2;
    sha1 = "f3adc26e6b313a14af1e4208bc539017c8dcccd7";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  includeAllQtDirs=true;
  buildInputs = [ cmake perl bzip2 qt4 alsaLib xineLib samba stdenv.gcc.libc kdelibs
                  automoc4 phonon strigi soprano cluceneCore ];
}
