{ kde, kdelibs, ffmpeg, popplerQt4, exiv2, taglib }:

kde {

  # todo: qmobipocket, epub
  buildInputs = [ kdelibs ffmpeg popplerQt4 exiv2 taglib ];

  meta = {
    description = "KDE file metadata something";
    license = "GPLv2";
  };
}
