{ stdenv, fetchurl, lib, cmake, perl, bzip2, xz, qt4, alsaLib, xineLib, samba, shared_mime_info
, kdelibs, automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdebase-runtime-4.4.0.tar.bz2;
    sha256 = "1zrwkf2l7nq0z4a9pm2plkynys65h77ai4s3cqlvzwlwhf4l3f1z";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  buildInputs = [ cmake perl bzip2 xz qt4 alsaLib xineLib samba stdenv.gcc.libc shared_mime_info
                  kdelibs automoc4 phonon strigi soprano cluceneCore ];
  meta = {
    description = "KDE runtime";
    longDescription = "Libraries and tools which supports running KDE desktop applications";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
