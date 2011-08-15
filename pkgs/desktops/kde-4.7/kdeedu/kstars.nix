{ kde, kdelibs, eigen, xplanet, indilib }:

kde {
  buildInputs = [ kdelibs eigen xplanet indilib ];

  meta = {
    description = "A KDE graphical desktop planetarium";
  };
}
