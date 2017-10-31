{ stdenv, qtSubmodule, qtbase, qtdeclarative, pkgconfig
, alsaLib, gstreamer, gst-plugins-base, libpulseaudio
, darwin
}:

with stdenv.lib;

qtSubmodule {
  name = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gstreamer gst-plugins-base libpulseaudio]
    ++ optional (stdenv.isLinux) alsaLib;
  outputs = [ "bin" "dev" "out" ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
  NIX_LDFLAGS = optionalString (stdenv.isDarwin) "-lobjc";
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
