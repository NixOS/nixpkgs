{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, kdelibs_experimental, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdemultimedia-4.3.3.tar.bz2;
    sha1 = "g6dfpv3mfpmgmg8sv7cazyhrl6zmw8fl";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib cdparanoia lame
                  kdelibs kdelibs_experimental automoc4 phonon ];
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
