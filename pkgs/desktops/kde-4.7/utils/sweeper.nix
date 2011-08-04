{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "Helps clean unwanted traces the user leaves on the system";
    kde = {
      name = "sweeper";
      module = "kdeutils";
      version = "1.7";
      versionFile = "main.cpp";
    };
  };
}
