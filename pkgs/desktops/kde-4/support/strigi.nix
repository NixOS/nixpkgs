args: with args;

stdenv.mkDerivation {
  name = "strigi-svn";
  src = svnSrc "strigi" "198arwd87l97gg5rs3p7rk9wiw1mrdsw9y0zwvrwnxs7glgj201h";
  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake zlib cluceneCore bzip2 libxml2 qt dbus
  log4cxx stdenv.gcc.libc exiv2 bison cppunit perl ];
}
