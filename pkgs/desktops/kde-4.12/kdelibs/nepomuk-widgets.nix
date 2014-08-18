{ kde, kdelibs, nepomuk_core, stdenv }:

kde {

  buildInputs = [ kdelibs nepomuk_core ];

  meta = {
    description = "NEPOMUK Widgets";
    license = stdenv.lib.licenses.gpl2;
  };
}
