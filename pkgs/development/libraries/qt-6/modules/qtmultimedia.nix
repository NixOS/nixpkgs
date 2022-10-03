{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, qtquick3d
, qtshadertools
, qtsvg
, pkg-config
, alsa-lib
, ffmpeg
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
, libva
}:

qtModule {
  pname = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative qtquick3d qtsvg qtshadertools ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg libpulseaudio elfutils libunwind alsa-lib wayland orc libva ];
  propagatedBuildInputs = [ gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi ];
}
