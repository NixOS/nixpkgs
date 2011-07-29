{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "A test application for KParts";
    kde = {
      name = "kpartloader";
      module = "kdesdk";
      version = "1.0";
      versionFile = "kpartloader.cpp";
    };
  };
}
