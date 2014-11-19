{ kde, kdelibs, stdenv }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A collection of plugins to handle mobipocket files";
    license = stdenv.lib.licenses.gpl2;
  };
}
