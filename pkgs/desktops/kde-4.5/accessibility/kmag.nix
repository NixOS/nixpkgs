{ kde, cmake, qt4, perl, automoc4, kdelibs }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "Screen magnifier for KDE";
    kde = {
      name = "kmag";
      module = "kdeaccessibility";
      version = "1.0";
      release = "4.5.1";
    };
  };
}

