{stdenv, fetchurl, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn,
 libvncserver, tapioca_qt, libmsn,
 libXtst, libXdamage, libXxf86vm,
 kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz}:

stdenv.mkDerivation {
  name = "kdenetwork-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdenetwork-4.2.3.tar.bz2;
    sha1 = "633432d049794f50143ed60197f6f0b5ac9011a7";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver tapioca_qt libmsn
		  libXtst libXdamage libXxf86vm
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz ];
}
