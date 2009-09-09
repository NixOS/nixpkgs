{ stdenv, fetchurl, lib, cmake, perl, bzip2, xz, qt4, alsaLib, xineLib, samba, shared_mime_info
, kdelibs, automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdebase-runtime-4.3.1.tar.bz2;
    sha1 = "4cb7a4ed093bacf01d5ecff1cbc60a8934dea59c";
  };
/*  CLUCENE_HOME=cluceneCore;*/
  includeAllQtDirs=true;
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
