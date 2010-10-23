{ kde, cmake, kdelibs, qt4, perl, automoc4 }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "Helps you format floppies with the filesystem of your choice";
    kde = {
      name = "kfloppy";
      module = "kdeutils";
      version = "4.5.2";
    };
  };
}
