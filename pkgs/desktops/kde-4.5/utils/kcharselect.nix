{ kde, cmake, kdelibs, qt4, perl, automoc4 }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "KDE character selection utility";
    kde = {
      name = "kcharselect";
      module = "kdeutils";
      version = "1.7";
      release = "4.5.1";
    };
  };
}
