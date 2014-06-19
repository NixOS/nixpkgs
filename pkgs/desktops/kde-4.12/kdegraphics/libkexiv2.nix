{ kde, kdelibs, exiv2, stdenv }:

kde {
  buildInputs = [ kdelibs exiv2 ];

  meta = {
    description = "Exiv2 support library";
    license = stdenv.lib.licenses.gpl2;
  };
}
