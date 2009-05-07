{stdenv, fetchurl, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt,
 shared_mime_info, libXScrnSaver,
 kdelibs, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdepim-4.2.3.tar.bz2;
    sha1 = "9d46fe2ce1bf183cce82d0d60a9a29ec3c53832f";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder = ./builder.sh;  
  buildInputs = [ cmake qt4 perl boost gpgme stdenv.gcc.libc libassuan libgpgerror libxslt
                  shared_mime_info libXScrnSaver
                  kdelibs kdepimlibs automoc4 phonon akonadi strigi soprano qca2 ];
}
