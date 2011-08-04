{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "aurorae-themes-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];
  
  meta = {
    kde = {
      name = "aurorae";
      module = "kdeartwork";
    };
  };
}
