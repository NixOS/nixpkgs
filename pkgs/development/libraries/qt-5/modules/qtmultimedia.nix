{ qtModule, lib, stdenv, qtbase, qtdeclarative, pkg-config
, alsa-lib, gstreamer, gst-plugins-base, libpulseaudio, wayland
}:

with lib;

qtModule {
  pname = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gstreamer gst-plugins-base libpulseaudio ]
    ++ optional (stdenv.isLinux) alsa-lib
    ++ optional (versionAtLeast qtbase.version "5.14.0" && stdenv.isLinux) wayland;
  outputs = [ "bin" "dev" "out" ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
  NIX_LDFLAGS = optionalString (stdenv.isDarwin) "-lobjc";
}
