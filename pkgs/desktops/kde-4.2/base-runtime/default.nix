{stdenv, fetchurl, cmake, perl, bzip2, qt4, alsaLib, xineLib, samba, kdelibs,
 automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.2.4";
  src = fetchurl {
    url = mirror://kde/Attic/4.2.4/src/kdebase-runtime-4.2.4.tar.bz2;

    sha1 = "dd829270b5fb21e4c24db5e7d16db6e99fe51c1d";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  includeAllQtDirs=true;
  buildInputs = [ cmake perl bzip2 qt4 alsaLib xineLib samba stdenv.gcc.libc kdelibs
                  automoc4 phonon strigi soprano cluceneCore ];
}
