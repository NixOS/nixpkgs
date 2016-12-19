{ stdenv, kde, kdelibs, soprano, shared_desktop_ontologies, exiv2, ffmpeg, taglib, poppler_qt4
, pkgconfig, doxygen, ebook_tools, automoc4, cmake, perl
}:

kde {

# TODO: qmobipocket

  buildInputs = [
    kdelibs soprano shared_desktop_ontologies taglib exiv2 ffmpeg
    poppler_qt4 ebook_tools
  ];

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig doxygen ];

  meta = {
    description = "NEPOMUK core";
    license = stdenv.lib.licenses.gpl2;
  };
}
