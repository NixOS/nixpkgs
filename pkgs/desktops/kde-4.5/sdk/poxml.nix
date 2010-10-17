{ kde, cmake, kdelibs, automoc4, antlr }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 antlr ];


  meta = {
    description = "Po<->xml tools";
    kde = {
      name = "poxml";
      module = "kdesdk";
      version = "4.5.2";
    };
  };
}
