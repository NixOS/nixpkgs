{ stdenv, fetchurl, lib, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn
, libvncserver, libmsn, giflib, gpgme, boost, libv4l, libotr
, libXi, libXtst, libXdamage, libXxf86vm
, kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz, strigi}:

stdenv.mkDerivation {
  name = "kdenetwork-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdenetwork-4.4.3.tar.bz2;
    sha256 = "1p2cx7vr811vrx4d0sqchgz5jy195rw2nbg01brk8i0ihiqfqycg";
  };
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver libmsn giflib gpgme boost stdenv.gcc.libc libv4l
                  libotr libXi libXtst libXdamage libXxf86vm
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz strigi ];
  patches = [ ./kget-cve.patch ];
  meta = {
    description = "KDE network utilities";
    longDescription = "Various network utilities for KDE such as a messenger client and network configuration interface";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
