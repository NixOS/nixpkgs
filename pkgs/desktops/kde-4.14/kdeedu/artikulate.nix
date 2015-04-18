{ kde, kdelibs, qt_gstreamer1 }:
kde {
  buildInputs = [ kdelibs qt_gstreamer1 ];

  meta = {
    description = "Artikulate is a pronunciation learning program for KDE.";
  };
}
