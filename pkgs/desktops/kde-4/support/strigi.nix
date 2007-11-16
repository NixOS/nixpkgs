args: with args;

stdenv.mkDerivation {
  name = "strigi-svn";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/strigi;
	rev = 732646;
	md5 = "15762f5a406ef84bc1cdd776b2ca9a82";
  };

  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake zlib cluceneCore bzip2 libxml2 qt dbus
  log4cxx stdenv.gcc.libc exiv2 bison cppunit perl ];
}
