{stdenv, fetchurl, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt,
 shared_mime_info, libXScrnSaver,
 kdelibs, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdepim-4.2.4.tar.bz2;
    sha1 = "d2328af104edf6471e3474ccea39710e0e1babc9";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder = ./builder.sh;  
  buildInputs = [ cmake qt4 perl boost gpgme stdenv.gcc.libc libassuan libgpgerror libxslt
                  shared_mime_info libXScrnSaver
                  kdelibs kdepimlibs automoc4 phonon akonadi strigi soprano qca2 ];
}
