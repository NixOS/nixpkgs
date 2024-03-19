{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, pkg-config
, alsa-lib
, gstreamer
, gst-plugins-base
, libpulseaudio
, wayland
}:

qtModule {
  pname = "qtmultimedia";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gstreamer gst-plugins-base ]
    # https://github.com/NixOS/nixpkgs/pull/169336 regarding libpulseaudio
    ++ lib.optionals stdenv.isLinux [ libpulseaudio alsa-lib wayland ];
  outputs = [ "bin" "dev" "out" ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
  NIX_LDFLAGS = lib.optionalString (stdenv.isDarwin) "-lobjc";
}
