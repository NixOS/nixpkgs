{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi ];

  meta = {
    description = "A KDE CVS frontend";
    kde = {
      name = "cervisia";
      module = "kdesdk";
      version = "3.7.0";
      versionFile = "cervisia/version.h";
    };
  };
}
