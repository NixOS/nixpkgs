{ kde, kdelibs, saneBackends }:

kde {
  buildInputs = [ kdelibs saneBackends ];

  meta = {
    description = "An image scanning library that provides a QWidget that contains all the logic needed to interface a sacanner";
    license = "GPLv2";
  };
}
