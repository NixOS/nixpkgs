{stdenv, fetchurl, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt,
 shared_mime_info, libXScrnSaver,
 kdelibs, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdepim-4.2.2.tar.bz2;
    sha1 = "abd6d9e7777cf192aa7919dce56644e942d8e2e9";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder = ./builder.sh;  
  buildInputs = [ cmake qt4 perl boost gpgme stdenv.gcc.libc libassuan libgpgerror libxslt
                  shared_mime_info libXScrnSaver
                  kdelibs kdepimlibs automoc4 phonon akonadi strigi soprano qca2 ];
}
