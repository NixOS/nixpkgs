{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A small utility to select a color";
    license = "GPLv2";
  };
}
