{ kde, cmake, kdelibs, automoc4, kdepimlibs }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 kdepimlibs ];


  meta = {
    description = "KDE accounts akonadi agent";
    kde = {
      name = "kdeaccounts-plugin";
      module = "kdesdk";
      version = "4.5.2";
    };
  };
}
