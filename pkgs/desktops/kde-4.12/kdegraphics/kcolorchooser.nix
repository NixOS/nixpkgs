{ kde, kdelibs, stdenv }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A small utility to select a color";
    license = stdenv.lib.licenses.gpl2;
  };
}
