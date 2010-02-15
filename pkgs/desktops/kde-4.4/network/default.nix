{ stdenv, fetchurl, lib, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn
, libvncserver, tapioca_qt, libmsn, giflib, gpgme, boost
, libXi, libXtst, libXdamage, libXxf86vm
, kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz, strigi}:

stdenv.mkDerivation {
  name = "kdenetwork-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdenetwork-4.4.0.tar.bz2;
    sha256 = "1y1qlig3fjnppn5qc6skfzf783wwchz8hh95kgqh112zwbmslvxi";
  };
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver tapioca_qt libmsn giflib gpgme boost stdenv.gcc.libc
		  libXi libXtst libXdamage libXxf86vm
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz strigi ];
  meta = {
    description = "KDE network utilities";
    longDescription = "Various network utilities for KDE such as a messenger client and network configuration interface";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
