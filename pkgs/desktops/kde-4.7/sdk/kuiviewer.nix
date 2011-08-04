{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "Displays Qt Designer's UI files";
    kde = {
      name = "kuiviewer";
      module = "kdesdk";
      version = "0.1";
      versionFile = "main.cpp";
    };
  };
}
