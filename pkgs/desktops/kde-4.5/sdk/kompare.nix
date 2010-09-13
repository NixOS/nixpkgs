{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "A program to view the differences between files and optionally generate a diff";
    kde = {
      name = "kompare";
      module = "kdesdk";
      version = "4.0.0";
      release = "4.5.1";
    };
  };
}
