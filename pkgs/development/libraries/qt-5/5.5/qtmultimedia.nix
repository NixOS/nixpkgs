{ qtSubmodule, qtbase, qtdeclarative
, alsaLib, gstreamer, gst_plugins_base, libpulseaudio
}:

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [
    alsaLib gstreamer gst_plugins_base libpulseaudio
  ];
}
