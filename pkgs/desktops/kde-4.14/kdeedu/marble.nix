{ kde, kdelibs, gpsd }:

kde {

# TODO: package QextSerialPort, libshp(shapelib), QtMobility, QtLocation, libwlocate, quazip

  buildInputs = [ kdelibs gpsd ];

  meta = {
    description = "Marble Virtual Globe";
  };
}
