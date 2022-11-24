{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, qtshadertools
, qtsvg
, pkg-config
, alsa-lib
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-libav
, gst-vaapi
, libpulseaudio
, wayland
, elfutils
, libunwind
, orc
}:

qtModule {
  pname = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative qtsvg qtshadertools ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpulseaudio elfutils libunwind alsa-lib wayland orc ];
  propagatedBuildInputs = [ gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi ];
}
