{ kde, kdelibs, qt_gstreamer1 }:
kde {
  buildInputs = [ kdelibs qt_gstreamer1 ];

  meta = {
    description = "A pronunciation learning program for KDE";
  };
}
