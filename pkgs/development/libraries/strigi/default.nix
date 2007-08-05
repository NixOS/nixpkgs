{ stdenv, fetchurl, zlib, bzip2, expat, pkgconfig, cluceneCore, cluceneContrib,
qt, cmake, dbus, libxml2 }:

stdenv.mkDerivation {
  name = "strigi-0.5.1";

  src = fetchurl {
    url = ftp://ftp.chg.ru/pub/sourceforge/s/st/strigi/strigi-0.5.1.tar.bz2;
    sha256 = "0n9ffqxdmz6ibki8rmac298z27937jddp7khmg2q8p15pnl5dq7i";
  };

  patchPhase="sed -e 's/ iconv / /' -i ../cmake/FindIconv.cmake;
  export CLUCENE_HOME=${cluceneCore}";
  buildInputs = [zlib cluceneCore cluceneContrib expat bzip2 pkgconfig qt cmake
  stdenv.gcc.libc dbus libxml2];

  meta = {
    description = "Strigi is a fast and light desktop search engine";
  };
}
