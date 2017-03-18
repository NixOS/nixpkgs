{ stdenv, qtSubmodule, qtbase, qtdeclarative, pkgconfig
, alsaLib, gstreamer, gst-plugins-base, libpulseaudio
}:

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [
    pkgconfig gstreamer gst-plugins-base libpulseaudio
  ] ++ stdenv.lib.optional stdenv.isLinux alsaLib;
  qmakeFlags = [ "GST_VERSION=1.0" ];
}
