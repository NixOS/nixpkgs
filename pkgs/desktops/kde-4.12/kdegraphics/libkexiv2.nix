{ kde, kdelibs, exiv2 }:

kde {
  buildInputs = [ kdelibs exiv2 ];

  meta = {
    description = "Exiv2 support library";
    license = "GPLv2";
  };
}
