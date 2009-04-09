{stdenv, fetchurl, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdemultimedia-4.2.2.tar.bz2;
    sha1 = "bacbf584cd38be5234bb5a4419a275c6f4164721";
  };
  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib cdparanoia
                  kdelibs automoc4 phonon ];
}
