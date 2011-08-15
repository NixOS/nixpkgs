{ kde, kdelibs, gpsd }:

kde {
  buildInputs = [ kdelibs gpsd ];

  meta = {
    description = "Marble Virtual Globe";
  };
}
