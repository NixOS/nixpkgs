{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdemultimedia-4.4.2.tar.bz2;
    sha256 = "15qq25ijnv0jsmxpc5fv7hwianxpqsz8i89j460kndm4pyplhdbj";
  };
  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib cdparanoia lame
                  kdelibs automoc4 phonon ];
  meta = {
    description = "KDE Multimedia";
    longDescription = ''
      Contains various Multimedia utilties for KDE such as a movie player and sound volume mixer.
    '';
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
