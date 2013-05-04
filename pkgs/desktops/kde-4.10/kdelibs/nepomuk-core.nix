{ kde, kdelibs, soprano, shared_desktop_ontologies, exiv2, ffmpeg, taglib, popplerQt4 }:

kde {

  buildInputs = [ kdelibs soprano shared_desktop_ontologies taglib exiv2 ffmpeg popplerQt4 ];

  meta = {
    description = "NEPOMUK core";
    license = "GPLv2";
  };
}
