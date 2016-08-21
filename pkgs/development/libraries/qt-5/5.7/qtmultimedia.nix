{ qtSubmodule, qtbase, qtdeclarative, pkgconfig, stdenv,
  alsaLib, gstreamer, gst-plugins-base, libpulseaudio, openal,
  OpenAL, AVFoundation, CoreMedia, QuartzCore, AppKit, Quartz,
  AudioUnit, AudioToolbox
}:

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = with stdenv; [ pkgconfig gstreamer gst-plugins-base ]
  ++ lib.optional isLinux [ alsaLib libpulseaudio openal ]
  ++ lib.optional isDarwin [ OpenAL AVFoundation CoreMedia QuartzCore AppKit Quartz
    AudioUnit AudioToolbox ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
}
