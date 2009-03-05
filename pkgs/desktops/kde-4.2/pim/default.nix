{stdenv, fetchurl, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt,
 shared_mime_info, libXScrnSaver,
 kdelibs, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdepim-4.2.1.tar.bz2;
    sha1 = "be97f4d34eb19b08c30988e07a75c24d5ccad08c";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder = ./builder.sh;  
  buildInputs = [ cmake qt4 perl boost gpgme stdenv.gcc.libc libassuan libgpgerror libxslt
                  shared_mime_info libXScrnSaver
                  kdelibs kdepimlibs automoc4 phonon akonadi strigi soprano qca2 ];
}
