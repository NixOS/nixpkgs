{ kde, kdelibs, stdenv }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "SVG KPart";
    license = stdenv.lib.licenses.gpl2;
  };
}
