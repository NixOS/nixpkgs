args: with args;

stdenv.mkDerivation {
  name = "strigi-svn";
  src = svnSrc "strigi" "0741b264c50d505b5e3a10b3de3ae35f4728aa6ca1fdc639268e6557dbbaa5ff";
  CLUCENE_HOME=cluceneCore;
  configureFlags = "-DENABLE_FAM=true";
  buildInputs = [ cmake zlib cluceneCore bzip2 libxml2 qt dbus.libs
    stdenv.gcc.libc exiv2 bison perl fam jdk ];
}
