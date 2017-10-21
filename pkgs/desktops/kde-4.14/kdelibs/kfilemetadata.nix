{ stdenv, kde, kdelibs, pkgconfig, doxygen, poppler_qt4, taglib, exiv2, ffmpeg }:

kde {
  buildInputs = [
    kdelibs poppler_qt4 taglib exiv2 ffmpeg
  ];

  nativeBuildInputs = [ pkgconfig doxygen ];

  meta = {
    description = "KFileMetaData";
    license = stdenv.lib.licenses.gpl2;
  };
}
