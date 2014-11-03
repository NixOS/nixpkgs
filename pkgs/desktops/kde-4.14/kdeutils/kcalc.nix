{ kde, kdelibs, gmp }:

kde {
  buildInputs = [ kdelibs gmp ];

  meta = {
    description = "KDE Calculator";
  };
}
