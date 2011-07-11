{ automoc4, cmake, kde, kdelibs, qt4, shared_mime_info, perl }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 shared_mime_info perl ];

  meta = {
    description = "Kate, the KDE Advanced Text Editor, as well as KWrite";
    license = "GPLv2";
    kde.name = "kate";
  };
}
