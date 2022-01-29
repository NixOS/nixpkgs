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
, wayland # wayland-client.h
, libunwind
}:

# TODO optional dependencies?
# libdw
# gstreamer-photography-1.0
# AVFoundation -> darwin platform
# WMF = Windows Media Foundation -> windows platform
# MMRenderer -> qnx platform

qtModule {
  pname = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative qtsvg qtshadertools ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gstreamer gst-plugins-base libpulseaudio libunwind ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib wayland ];
  outputs = [ "out" "dev" ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lobjc";
}
