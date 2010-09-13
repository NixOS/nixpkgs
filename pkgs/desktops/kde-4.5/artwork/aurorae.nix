{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "aurorae-themes-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    kde = {
      name = "aurorae";
      module = "kdeartwork";
      version = "4.5.1";
    };
  };
}
