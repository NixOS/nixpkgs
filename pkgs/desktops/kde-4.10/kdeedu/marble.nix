{ kde, kdelibs, gpsd }:

kde {
#todo: package QextSerialPort, libshp(shapelib), QtMobility, QtLocation, libwlocate
  buildInputs = [ kdelibs gpsd ];

  meta = {
    description = "Marble Virtual Globe";
  };
}
