{stdenv, fetchurl, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn,
 libvncserver, tapioca_qt, libmsn,
 libXtst, libXdamage, libXxf86vm,
 kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz}:

stdenv.mkDerivation {
  name = "kdenetwork-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdenetwork-4.2.2.tar.bz2;
    sha1 = "335a09012602400318d6e703fdcc390f5a2f7761";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver tapioca_qt libmsn
		  libXtst libXdamage libXxf86vm
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz ];
}
