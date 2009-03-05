{stdenv, fetchurl, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn,
 libvncserver, tapioca_qt, libmsn,
 libXtst, libXdamage,
 kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz}:

stdenv.mkDerivation {
  name = "kdenetwork-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdenetwork-4.2.1.tar.bz2;
    sha1 = "d6d730c167cd72d43904715014b2adc8f7d5bc1e";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver tapioca_qt libmsn
		  libXtst libXdamage
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz ];
}
