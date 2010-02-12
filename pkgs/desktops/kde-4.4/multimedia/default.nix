{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, kdelibs_experimental, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdemultimedia-4.4.0.tar.bz2;
    sha256 = "0zvllvwj2nj7qh9jq5048d37jj55cml7d0y1k4rk1ba31mmp7vrn";
  };
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
