{ kde, kdelibs, eigen, xplanet, indilib }:

kde {
#todo:wcslib
  buildInputs = [ kdelibs eigen xplanet indilib ];

  meta = {
    description = "A KDE graphical desktop planetarium";
  };
}
