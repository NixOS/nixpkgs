{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "Tool to visualise file and directory sizes";
    kde = {
      name = "filelight";
      module = "kdeutils";
      version = "1.10";
    };
  };
}
