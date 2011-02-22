{ stdenv, fetchurl, cmake, qt4, perl, bzip2, libxml2, expat, exiv2
, cluceneCore
}:

stdenv.mkDerivation rec {
  name = "strigi-${version}";
  version = "0.7.2";

  src = fetchurl {
    url = "http://www.vandenoever.info/software/strigi/${name}.tar.bz2";
    sha256 = "1f1ac27cjm5m4iwsgvd7nylr0md0a95przkbpsdq7l90wjxj390w";
  };
  includeAllQtDirs=true;

  CLUCENE_HOME = cluceneCore;

  # Dependencies such as SQLite and FAM are unreliable in this release
  buildInputs = [
    cmake perl qt4 bzip2 stdenv.gcc.libc libxml2 expat exiv2 cluceneCore
  ];

  meta = {
    homepage = http://strigi.sourceforge.net;
    description = "A very fast and efficient crawler to index data on your harddrive";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (qt4.meta) platforms;
  };
}
