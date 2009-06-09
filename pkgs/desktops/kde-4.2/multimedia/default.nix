{stdenv, fetchurl, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdemultimedia-4.2.4.tar.bz2;
    sha1 = "ab1f9e38ab38d502aa771a70137ded811f40ad1c";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib cdparanoia
                  kdelibs automoc4 phonon ];
}
