{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  pkg-config,
  glibc,
  openssl,
  libkrunfw,
  rustc,
  sevVariant ? false,
}:

stdenv.mkDerivation rec {
  pname = "libkrun";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    rev = "refs/tags/v${version}";
    hash = "sha256-rrNiqwx4aEOB3fTyv8xcZEDsNJX4NNPhp13W0qnl1O0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-6Zfy0LtxUDZzwlhul2fZpsI1c7GWntAMfsT6j+QefVs=";
  };

  nativeBuildInputs =
    [
      rustPlatform.cargoSetupHook
      cargo
      rustc
    ]
    ++ lib.optionals sevVariant [
      pkg-config
    ];

  buildInputs =
    [
      (libkrunfw.override { inherit sevVariant; })
      glibc
      glibc.static
    ]
    ++ lib.optionals sevVariant [
      openssl
    ];

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
    ]
    ++ lib.optionals sevVariant [
      "SEV=1"
    ];

  meta = with lib; {
    description = "A dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = libkrunfw.meta.platforms;
  };
}
