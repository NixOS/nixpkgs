{ stdenv, fetchurl, cmake, perl, bzip2, qt4, libxml2, exiv2, fam
, log4cxx, cluceneCore
}:

stdenv.mkDerivation {
  name = "strigi-0.6.4";
  
  src = fetchurl {
    url = mirror://sourceforge/strigi/strigi-0.6.4.tar.bz2;
    md5 = "324fd9606ac77765501717ff92c04f9a";
  };

  includeAllQtDirs = true;
  
  CLUCENE_HOME = cluceneCore;
  
  buildInputs = [
    cmake perl bzip2 stdenv.gcc.libc qt4 libxml2 exiv2 fam /* log4cxx */ cluceneCore
  ];

  meta = {
    homepage = http://strigi.sourceforge.net/;
    description = "A very fast and efficient crawler to index data on your harddrive";
  };
}
