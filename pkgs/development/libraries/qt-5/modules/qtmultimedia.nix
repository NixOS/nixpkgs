{ qtModule, stdenv, qtbase, qtdeclarative, pkgconfig
, alsaLib, gstreamer, gst-plugins-base, libpulseaudio
}:

with stdenv.lib;

qtModule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gstreamer gst-plugins-base libpulseaudio]
    ++ optional (stdenv.isLinux) alsaLib;
  outputs = [ "bin" "dev" "out" ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
  NIX_LDFLAGS = optionalString (stdenv.isDarwin) "-lobjc";
}
