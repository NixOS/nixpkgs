{ stdenv, fetchurl, lib, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac, cdparanoia, lame
, kdelibs, kdelibs_experimental, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdemultimedia-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdemultimedia-4.3.5.tar.bz2;
    sha256 = "0yay90vh4j4bc4dv7ya0n8cl937lp47a4mwpnyhcn81wjyfavggx";
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
