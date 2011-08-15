{ kde, kdelibs, kdegraphics }:

kde {
  buildInputs = [ kdelibs kdegraphics.okular ];

  meta = {
    description = "A collection of plugins to handle mobipocket files";
    license = "GPLv2";
  };
}
