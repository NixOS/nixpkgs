{ stdenv, fetchurl, lib, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn
, libvncserver, libmsn, giflib, gpgme, boost, libv4l, libotr
, libXi, libXtst, libXdamage, libXxf86vm
, kdelibs, kdepimlibs, automoc4, phonon, qca2, soprano, qimageblitz, strigi}:

stdenv.mkDerivation {
  name = "kdenetwork-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdenetwork-4.4.5.tar.bz2;
    sha256 = "1rpf5kmcc3cw7vlj9g8px19b5vr4hnza8r78bw1g8i7vwcng57ya";
  };
  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
                  libvncserver libmsn giflib gpgme boost stdenv.gcc.libc libv4l
                  libotr libXi libXtst libXdamage libXxf86vm
                  kdelibs kdepimlibs automoc4 phonon qca2 soprano qimageblitz strigi ];
  meta = {
    description = "KDE network utilities";
    longDescription = "Various network utilities for KDE such as a messenger client and network configuration interface";
    license = "GPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers platforms;
  };
}
