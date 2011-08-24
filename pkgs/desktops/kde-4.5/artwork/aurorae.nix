{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "aurorae-themes-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  
  meta = {
    kde = {
      name = "aurorae";
      module = "kdeartwork";
    };
  };
}
