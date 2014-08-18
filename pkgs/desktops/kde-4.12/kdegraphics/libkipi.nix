{ kde, kdelibs, stdenv }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Interface library to kipi-plugins";
    license = stdenv.lib.licenses.gpl2;
  };
}
