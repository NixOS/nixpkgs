{ stdenv, kde, kdelibs, nepomuk_core }:

kde {

  buildInputs = [ kdelibs nepomuk_core ];

  meta = {
    description = "NEPOMUK Widgets";
    license = stdenv.lib.licenses.gpl2;
  };
}
