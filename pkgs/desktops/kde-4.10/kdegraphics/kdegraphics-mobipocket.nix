{ kde, kdelibs, okular }:

kde {
  buildInputs = [ kdelibs okular ];

  meta = {
    description = "A collection of plugins to handle mobipocket files";
    license = "GPLv2";
  };
}
