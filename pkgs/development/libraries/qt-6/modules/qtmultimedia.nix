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
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-libav
, gst-vaapi
, ffmpeg_6
, libpulseaudio
, wayland
, libXrandr
, elfutils
, libunwind
, orc
, VideoToolbox
}:

qtModule {
  pname = "qtmultimedia";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libunwind orc ffmpeg_6 ]
    ++ lib.optionals stdenv.isLinux [ libpulseaudio elfutils alsa-lib wayland libXrandr ];
  propagatedBuildInputs = [ qtbase qtdeclarative qtsvg qtshadertools qtquick3d ]
    ++ lib.optionals stdenv.isLinux [ gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi ]
    ++ lib.optionals stdenv.isDarwin [ VideoToolbox ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-include AudioToolbox/AudioToolbox.h";
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin
    "-framework AudioToolbox";
}
