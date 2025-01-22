{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitea,
  cmake,
  python3,
  boost,
  libsodium,
  openssl,
  rapidjson,
  readline,
  unbound,
  zeromq,
  darwin,
}:

let
  # submodules
  miniupnp = fetchFromGitHub {
    owner = "miniupnp";
    repo = "miniupnp";
    rev = "miniupnpc_2_2_1";
    hash = "sha256-opd0hcZV+pjC3Mae3Yf6AR5fj6xVwGm9LuU5zEPxBKc=";
  };
  supercop = fetchFromGitHub {
    owner = "monero-project";
    repo = "supercop";
    rev = "633500ad8c8759995049ccd022107d1fa8a1bbc9";
    hash = "sha256-26UmESotSWnQ21VbAYEappLpkEMyl0jiuCaezRYd/sE=";
  };
  randomwow = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wownero";
    repo = "RandomWOW";
    rev = "27b099b6dd6fef6e17f58c6dfe00009e9c5df587";
    hash = "sha256-imiXr4irXeKiQ6VMd6f3MJ46zvdvymnRdHGgnEvkT+o=";
  };
in
stdenv.mkDerivation rec {
  pname = "wownero";
  version = "0.11.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wownero";
    repo = "wownero";
    tag = "v${version}";
    hash = "sha256-EioXFfUQ+CV6+Ipef1wbmc+taKI98I420J7eqzz15Ss=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=cast-user-defined"
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=int-conversion"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs =
    [
      boost
      libsodium
      openssl
      rapidjson
      readline
      unbound
      zeromq
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.IOKit
    ];

  postUnpack = ''
    rm -r $sourceRoot/external/miniupnp
    ln -s ${miniupnp} $sourceRoot/external/miniupnp

    rm -r $sourceRoot/external/randomwow
    ln -s ${randomwow} $sourceRoot/external/randomwow

    rm -r $sourceRoot/external/supercop
    ln -s ${supercop} $sourceRoot/external/supercop
  '';

  cmakeFlags = [
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DMANUAL_SUBMODULES=ON"
  ];

  meta = with lib; {
    description = ''
      A privacy-centric memecoin that was fairly launched on April 1, 2018 with
      no pre-mine, stealth-mine or ICO
    '';
    longDescription = ''
      Wownero has a maximum supply of around 184 million WOW with a slow and
      steady emission over 50 years. It is a fork of Monero, but with its own
      genesis block, so there is no degradation of privacy due to ring
      signatures using different participants for the same tx outputs on
      opposing forks.
    '';
    homepage = "https://wownero.org/";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
