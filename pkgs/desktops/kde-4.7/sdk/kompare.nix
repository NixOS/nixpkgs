{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "A program to view the differences between files and optionally generate a diff";
    kde = {
      name = "kompare";
      module = "kdesdk";
      version = "4.0.0";
      versionFile = "main.cpp";
    };
  };
}
