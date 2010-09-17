{ kde, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac,
cdparanoia, lame , kdelibs, automoc4, ffmpeg, libmusicbrainz2, libtunepimp }:

kde.package {

  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib
    cdparanoia lame kdelibs automoc4 ffmpeg libmusicbrainz2 libtunepimp ];

  meta = {
    description = "KDE Multimedia";
    longDescription = ''
      Contains various Multimedia utilties for KDE such as a movie player and sound volume mixer.
    '';
    license = "GPL";
    kde = {
      name = "kdemultimedia";
      version = "4.5.1";
    };
  };
}
