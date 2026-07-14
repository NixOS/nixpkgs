{
  qtModule,
  lib,
  stdenv,
  llvmPackages,
  qtbase,
  qtmultimedia,
  pkg-config,
  flite,
  alsa-lib,
  speechd-minimal,
}:

qtModule {
  pname = "qtspeech";
  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.lld ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    flite
    alsa-lib
    speechd-minimal
  ];
  propagatedBuildInputs = [
    qtbase
    qtmultimedia
  ];
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Work around ld64's libc++ hardening issue.
    # TODO: Remove once #536365 reaches this branch.
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };
}
