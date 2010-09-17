{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "A KDE 4 project template generator";
    kde = {
      name = "cervisia";
      module = "kdesdk";
      version = "0.1";
      release = "4.5.1";
    };
  };
}
