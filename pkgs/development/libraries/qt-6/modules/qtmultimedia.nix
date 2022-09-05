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
  buildInputs = [ gstreamer gst-plugins-base libpulseaudio elfutils libunwind alsa-lib wayland orc ];
}
