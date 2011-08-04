{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "A KDE 4 project template generator";
    kde = {
      name = "kapptemplate";
      module = "kdesdk";
      version = "0.1";
      versionFile = "kapptemplate/main.cpp";
    };
  };
}
