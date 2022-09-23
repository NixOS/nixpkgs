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
  qtInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gstreamer gst-plugins-base ]
    # https://github.com/NixOS/nixpkgs/pull/169336 regarding libpulseaudio
    ++ lib.optionals stdenv.isLinux [ libpulseaudio alsa-lib ]
    ++ lib.optional (lib.versionAtLeast qtbase.version "5.14.0" && stdenv.isLinux) wayland;
  outputs = [ "bin" "dev" "out" ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
  NIX_LDFLAGS = lib.optionalString (stdenv.isDarwin) "-lobjc";
}
