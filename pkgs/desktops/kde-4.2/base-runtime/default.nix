{stdenv, fetchurl, cmake, perl, bzip2, qt4, alsaLib, xineLib, samba, kdelibs,
 automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdebase-runtime-4.2.2.tar.bz2;
    sha1 = "0b100ceb77fa2e8cbe5303f7fea28b02117c7658";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  buildInputs = [ cmake perl bzip2 qt4 alsaLib xineLib samba stdenv.gcc.libc kdelibs
                  automoc4 phonon strigi soprano cluceneCore ];
}
