{ kdePackage, cmake, perl, qt4, alsaLib, libvorbis, xineLib, taglib, flac,
cdparanoia, lame , kdelibs, automoc4, ffmpeg}:

kdePackage {
  pn = "kdemultimedia";
  v = "4.5.0";

  buildInputs = [ cmake perl qt4 alsaLib libvorbis xineLib flac taglib
    cdparanoia lame kdelibs automoc4 ffmpeg ];

  meta = {
    description = "KDE Multimedia";
    longDescription = ''
      Contains various Multimedia utilties for KDE such as a movie player and sound volume mixer.
    '';
    license = "GPL";
  };
}
