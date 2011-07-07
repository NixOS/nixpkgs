{ kde, cmake, kdelibs, automoc4, kdepimlibs }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 kdepimlibs ];

  meta = {
    description = "KDE bugzilla client";
    kde = {
      name = "kbugbuster";
      module = "kdesdk";
      version = "3.80.3";
      versionFile = "version.h";
    };
  };
}
