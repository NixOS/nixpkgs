{stdenv, fetchurl, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdemultimedia-4.2.0.tar.bz2;
    md5 = "3e944c87888ac1ac5b11d3722dd31f88";
  };
  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib cdparanoia
                  kdelibs automoc4 phonon ];
}
