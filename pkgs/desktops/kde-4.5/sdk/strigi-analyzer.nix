{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "Strigi analyzers for diff, po and ts";
    kde = {
      name = "strigi-analyzer";
      module = "kdesdk";
      version = "4.5.1";
    };
  };
}
