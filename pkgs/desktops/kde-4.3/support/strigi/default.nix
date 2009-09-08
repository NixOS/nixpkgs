{ stdenv, fetchurl, lib, cmake, qt4, perl, bzip2, libxml2, expat, exiv2
, cluceneCore
}:

stdenv.mkDerivation {
  name = "strigi-0.6.4";
  
  src = fetchurl {
    url = mirror://sourceforge/strigi/strigi-0.6.4.tar.bz2;
    md5 = "324fd9606ac77765501717ff92c04f9a";
  };

  includeAllQtDirs = true;
  
  CLUCENE_HOME = cluceneCore;
  
  # Dependencies such as SQLite and FAM are unreliable in this release
  buildInputs = [
    cmake perl qt4 bzip2 stdenv.gcc.libc libxml2 expat exiv2 cluceneCore
  ];

  meta = {
    homepage = http://strigi.sourceforge.net;
    description = "A very fast and efficient crawler to index data on your harddrive";
    license = "LGPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
