{ qtSubmodule, qtbase, qtdeclarative, pkgconfig
, alsaLib, gstreamer, gst-plugins-base, libpulseaudio
}:

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [
    pkgconfig alsaLib gstreamer gst-plugins-base libpulseaudio
  ];
  configureFlags = "GST_VERSION=1.0";
  postFixup = ''
    fixQtModuleCMakeConfig "Multimedia"
    fixQtModuleCMakeConfig "MultimediaWidgets"
  '';
}
