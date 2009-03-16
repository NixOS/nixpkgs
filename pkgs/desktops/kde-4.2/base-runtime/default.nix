{stdenv, fetchurl, cmake, perl, bzip2, qt4, alsaLib, xineLib, samba, kdelibs,
 automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdebase-runtime-4.2.1.tar.bz2;
    sha1 = "e80d1882d36e4c9737e80fcb5080bc683403ddb5";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  buildInputs = [ cmake perl bzip2 qt4 alsaLib xineLib samba stdenv.gcc.libc kdelibs
                  automoc4 phonon strigi soprano cluceneCore ];
}
