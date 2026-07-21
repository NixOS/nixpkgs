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
  # TODO: Clean up on `staging`.
  llvmPackages,
}:

qtModule {
  pname = "qtmultimedia";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  nativeBuildInputs = [
    pkg-config
  ]
  # TODO: Clean up on `staging`.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.lld
  ];
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
  env = lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
    NIX_LDFLAGS = "-lobjc";
    # TODO: Clean up on `staging`.
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };
}
