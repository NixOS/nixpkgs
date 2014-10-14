{ stdenv, kde, kdelibs, pkgconfig, doxygen, popplerQt4, taglib, exiv2, ffmpeg }:

kde {
  buildInputs = [
    kdelibs popplerQt4 taglib exiv2 ffmpeg
  ];

  nativeBuildInputs = [ pkgconfig doxygen ];

  meta = {
    description = "KFileMetaData";
    license = stdenv.lib.licenses.gpl2;
  };
}
