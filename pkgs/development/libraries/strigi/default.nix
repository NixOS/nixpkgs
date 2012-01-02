{ stdenv, fetchurl, cmake, qt4, perl, bzip2, libxml2, exiv2
, clucene_core, fam, zlib, dbus_tools, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "strigi-${version}";
  version = "0.7.5";

  src = fetchurl {
    url = "http://www.vandenoever.info/software/strigi/${name}.tar.bz2";
    sha256 = "16qqnlh0dy3r92shzm2q36h5qi3m06pihr4h5cq944hpvqz5w7qi";
  };
  
  includeAllQtDirs = true;

  CLUCENE_HOME = clucene_core;

  buildInputs =
    [ zlib bzip2 stdenv.gcc.libc libxml2 qt4 exiv2 clucene_core fam dbus_tools ];

  buildNativeInputs = [ cmake pkgconfig perl ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://strigi.sourceforge.net;
    description = "A very fast and efficient crawler to index data on your harddrive";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (qt4.meta) platforms;
  };
}
