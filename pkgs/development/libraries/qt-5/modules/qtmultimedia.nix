{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  pkg-config,
  alsa-lib,
  gst_all_1,
  libpulseaudio,
  wayland,
}:

qtModule {
  pname = "qtmultimedia";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    with gst_all_1;
    [
      gstreamer
      gst-plugins-base
    ]
    # https://github.com/NixOS/nixpkgs/pull/169336 regarding libpulseaudio
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libpulseaudio
      alsa-lib
      wayland
    ];
  outputs = [
    "bin"
    "dev"
    "out"
  ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
  NIX_LDFLAGS = lib.optionalString (stdenv.hostPlatform.isDarwin) "-lobjc";
}
