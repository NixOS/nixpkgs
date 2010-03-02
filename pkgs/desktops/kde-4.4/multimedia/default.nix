{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.4.1";
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdemultimedia-4.4.1.tar.bz2;
    sha256 = "1ahm16y65m9k5g1mzrzy26hdyb8zrn8jwfkq4p3s9vixr02fijkg";
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
