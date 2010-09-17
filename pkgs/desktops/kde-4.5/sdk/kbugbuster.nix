{ kde, cmake, kdelibs, automoc4, kdepimlibs }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 kdepimlibs ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "KDE bugzilla client";
    kde = {
      name = "kbugbuster";
      module = "kdesdk";
      version = "3.80.3";
      release = "4.5.1";
    };
  };
}
