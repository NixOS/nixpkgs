{ stdenv, fetchurl, lib, cmake, qt4, perl, bzip2, libxml2, expat, exiv2
, cluceneCore
}:

stdenv.mkDerivation rec {
  name = "strigi-0.7.1";
  
  src = fetchurl {
    url = "http://www.vandenoever.info/software/strigi/${name}.tar.bz2";
    sha256 = "1cra4jlpd7cdvckwalfjrf2224qvhbkmxdd3sn02q9jhv830b0yi";
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
