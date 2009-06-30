{stdenv, fetchurl, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn,
 libvncserver, tapioca_qt, libmsn,
 libXtst, libXdamage, libXxf86vm,
 kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz}:

stdenv.mkDerivation {
  name = "kdenetwork-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdenetwork-4.2.4.tar.bz2;
    sha1 = "31f3f1c44690339ce523c309a3d2c131563d9f97";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver tapioca_qt libmsn
		  libXtst libXdamage libXxf86vm
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz ];
}
