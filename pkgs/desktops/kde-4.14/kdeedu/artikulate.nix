{ kde, kdelibs, qt-gstreamer1 }:
kde {
  buildInputs = [ kdelibs qt-gstreamer1 ];

  meta = {
    description = "A pronunciation learning program for KDE";
  };
}
