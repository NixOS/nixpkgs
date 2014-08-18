{ kde, kdelibs, soprano, shared_desktop_ontologies, exiv2, ffmpeg, taglib, popplerQt4
, pkgconfig, doxygen, ebook_tools
}:

kde {

# TODO: qmobipocket

  buildInputs = [
    kdelibs soprano shared_desktop_ontologies taglib exiv2 ffmpeg
    popplerQt4 ebook_tools
  ];

  nativeBuildInputs = [ pkgconfig doxygen ];

  meta = {
    description = "NEPOMUK core";
    license = "GPLv2";
  };
}
