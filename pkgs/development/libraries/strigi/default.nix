{ stdenv, fetchurl, zlib, bzip2, expat, pkgconfig, cluceneCore, cluceneContrib,
qt, cmake, dbus, libxml2, perl }:

stdenv.mkDerivation {
  name = "strigi-0.5.3dev";

  src = fetchurl {
    url = http://repo.calcforge.org/f8/strigi-0.5.3.tar.bz2;
    sha256 = "0rv7l2s4r022hrsw3jw0pvxh0yzlaw53jhmjxi3cbi6mdvc1y2sv";
  };

  patchPhase="sed -e 's/ iconv / /' -i ../cmake/FindIconv.cmake;
  export CLUCENE_HOME=${cluceneCore}";
  buildInputs = [zlib cluceneCore cluceneContrib expat bzip2 pkgconfig qt cmake
  stdenv.gcc.libc dbus libxml2 perl];

  meta = {
    description = "Strigi is a fast and light desktop search engine";
  };
}
