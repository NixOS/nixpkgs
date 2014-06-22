{ kde, kdelibs, pkgconfig, qt_gstreamer }:
kde {

  buildInputs = [ kdelibs qt_gstreamer ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Pronunciation training";
  };
}
