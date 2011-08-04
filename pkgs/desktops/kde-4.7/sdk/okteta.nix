{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, shared_mime_info, qca2 }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi shared_mime_info qca2 ];

  meta = {
    description = "KDE byte editor";
    kde = {
      name = "okteta";
      module = "kdesdk";
      version = "0.5.3";
      versionFile = "program/about.cpp";
    };
  };
}
