{stdenv, fetchurl, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt,
 shared_mime_info, libXScrnSaver,
 kdelibs, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdepim-4.2.0.tar.bz2;
    md5 = "a80631de21930b2544c86722138aaa6c";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder = ./builder.sh;  
  buildInputs = [ cmake qt4 perl boost gpgme libassuan libgpgerror libxslt
                  shared_mime_info libXScrnSaver
                  kdelibs kdepimlibs automoc4 phonon akonadi strigi soprano qca2 ];
}
