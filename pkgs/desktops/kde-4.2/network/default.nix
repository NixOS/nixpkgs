{stdenv, fetchurl, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn,
 libvncserver,
 libXtst,
 kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz, decibel}:

stdenv.mkDerivation {
  name = "kdenetwork-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdenetwork-4.2.0.tar.bz2;
    md5 = "0ea1628e11d398fdf45276a35edd3cae";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver
		  libXtst
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz decibel ];
}
