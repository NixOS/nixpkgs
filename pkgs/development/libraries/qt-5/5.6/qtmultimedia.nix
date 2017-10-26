{ qtSubmodule, qtbase, qtdeclarative, pkgconfig
, alsaLib, gstreamer, gst-plugins-base, libpulseaudio
}:

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    alsaLib gstreamer gst-plugins-base libpulseaudio
  ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
}
