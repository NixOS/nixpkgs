{ qtSubmodule, qtbase, qtdeclarative
, alsaLib, gstreamer, gst-plugins-base, libpulseaudio
}:

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [
    alsaLib gstreamer gst-plugins-base libpulseaudio
  ];
}
