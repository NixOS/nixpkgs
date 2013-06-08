{ kde, kdelibs, gsl, libqalculate, eigen }:

kde {
  buildInputs = [ kdelibs gsl libqalculate eigen ];

  meta = {
    description = "A KDE interactive physical simulator";
    kde = {
      name = "step";
    };
  };
}
