{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A KDE mathematical function plotter";
    kde = {
      name = "kmplot";
    };
  };
}
