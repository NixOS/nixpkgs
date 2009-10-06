{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, kdelibs_experimental, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/kdemultimedia-4.3.2.tar.bz2;
    sha1 = "szfz48dhwz3q7xfay41rwyc5hr91gzi2";
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
