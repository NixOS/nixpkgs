{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdemultimedia-4.4.3.tar.bz2;
    sha256 = "0lpwmplwiy6j9rc8vhwp95c64ym7hc8zh6zm41578pvdqgdy6y5j";
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
