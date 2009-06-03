{stdenv, fetchurl, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdemultimedia-4.2.3.tar.bz2;
    sha1 = "ebf2d0f04dd8ab2c10a3505a2c7a3468173e369e";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib cdparanoia
                  kdelibs automoc4 phonon ];
}
