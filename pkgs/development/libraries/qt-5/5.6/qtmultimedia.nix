{ qtSubmodule, qtbase, qtdeclarative, pkgconfig
, alsaLib, gstreamer, gst-plugins-base, libpulseaudio
}:

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [
    pkgconfig alsaLib gstreamer gst-plugins-base libpulseaudio
  ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
}
