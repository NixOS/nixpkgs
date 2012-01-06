{ kde, kdelibs, libtool }:

kde {
  buildInputs = [ kdelibs libtool ];

  meta = {
    description = "Measures start up time of a KDE application";
  };
}
