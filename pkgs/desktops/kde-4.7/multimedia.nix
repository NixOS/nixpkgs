{ kde, cmake, perl, qt4, phonon, alsaLib, libvorbis, taglib, flac
, cdparanoia, lame, kdelibs, automoc4, ffmpeg, libmusicbrainz3, libtunepimp }:

kde.package {

  buildInputs =
    # Note: kdemultimedia can use xine-lib, but it doesn't seem useful
    # without the Phonon Xine backend.
    [ cmake kdelibs qt4 automoc4 phonon cdparanoia taglib libvorbis
      libmusicbrainz3 libtunepimp ffmpeg flac lame
    ];

  meta = {
    description = "KDE multimedia programs such as a movie player and volume utility";
    license = "GPL";
    kde.name = "kdemultimedia";
  };
}
