{stdenv, fetchurl, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdemultimedia-4.2.1.tar.bz2;
    sha1 = "5382c963fae0ca6528c326b73234525e170a5c2e";
  };
  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib cdparanoia
                  kdelibs automoc4 phonon ];
}
