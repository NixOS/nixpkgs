{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, kdepimlibs }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi kdepimlibs ];

  meta = {
    description = "KDE accounts akonadi agent";
    kde = {
      name = "kdeaccounts-plugin";
      module = "kdesdk";
    };
  };
}
