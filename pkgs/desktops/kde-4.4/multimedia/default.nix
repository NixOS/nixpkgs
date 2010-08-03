{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdemultimedia-4.4.5.tar.bz2;
    sha256 = "186la58w7572s47yrs01q3qk0ffiqn9357a6gdk8263x9myc2xkz";
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
    inherit (kdelibs.meta) maintainers platforms;
  };
}
