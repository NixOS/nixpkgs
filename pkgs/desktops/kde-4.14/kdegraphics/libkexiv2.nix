{ stdenv, kde, kdelibs, exiv2 }:

kde {
  buildInputs = [ kdelibs exiv2 ];

  meta = {
    description = "Exiv2 support library";
    license = stdenv.lib.licenses.gpl2;
  };
}
