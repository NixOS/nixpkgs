{ stdenv, fetchurl, lib, cmake, perl, bzip2, xz, qt4, alsaLib, xineLib, samba, shared_mime_info
, kdelibs, automoc4, phonon, strigi, soprano, cluceneCore}:

stdenv.mkDerivation {
  name = "kdebase-runtime-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdebase-runtime-4.3.4.tar.bz2;
    sha1 = "871d23457c4a2676704722e2e3b7194d447904ee";
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
