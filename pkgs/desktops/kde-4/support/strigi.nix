args: with args;

stdenv.mkDerivation {
  name = "strigi-svn";
  src = svnSrc "strigi" "0zmfy7ga4y49hl3rgw8ypqag36k78k2wfkkxka8xskrd249516ha";
  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake zlib cluceneCore bzip2 libxml2 qt dbus
  log4cxx stdenv.gcc.libc exiv2 bison cppunit perl ];
}
