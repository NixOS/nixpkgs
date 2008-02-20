args: with args;

stdenv.mkDerivation {
  name = "strigi-svn";
  src = svnSrc "strigi" "0dp145n93bqp91lvk2n10mghppyhdm3anh1l3a18d20hrvsm42z5";
  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake zlib cluceneCore bzip2 libxml2 qt dbus
  log4cxx stdenv.gcc.libc exiv2 bison cppunit perl ];
}
