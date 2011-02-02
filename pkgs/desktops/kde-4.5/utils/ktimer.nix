{ kde, cmake, kdelibs, qt4, perl, automoc4 }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "KDE Timer";
    kde = {
      name = "ktimer";
      module = "kdeutils";
      version = "0.6";
      versionFile = "main.cpp";
    };
  };
}
