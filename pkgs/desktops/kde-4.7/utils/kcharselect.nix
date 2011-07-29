{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "KDE character selection utility";
    kde = {
      name = "kcharselect";
      module = "kdeutils";
      version = "1.9";
      versionFile = "main.cc";
    };
  };
}
