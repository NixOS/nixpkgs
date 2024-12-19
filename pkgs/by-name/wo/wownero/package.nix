{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
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
  randomwow = fetchFromGitHub {
    owner = "wownero-project";
    repo = "RandomWOW";
    rev = "607bad48f3687c2490d90f8c55efa2dcd7cbc195";
    hash = "sha256-CJv96TbPv1k/C7MQWEntE6khIRX1iIEiF9wEdsQGiFQ=";
  };
in
stdenv.mkDerivation rec {
  pname = "wownero";
  version = "0.11.0.1";

  src = fetchFromGitHub {
    owner = "wownero-project";
    repo = "wownero";
    rev = "v${version}";
    fetchSubmodules = false;
    hash = "sha256-zmGsSbPpVwL0AhCQkdMKORruM5kYrrLe/BYfMphph8c=";
  };

  patches = [
    # Fix gcc-13 build due to missing <cstdint> neaders
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://git.wownero.com/wownero/wownero/commit/f983ac77805a494ea4a05a00398c553e1359aefd.patch";
      hash = "sha256-9acQ4bHAKFR+lMgrpQyBmb+9YZYi1ywHoo1jBcIgmGs=";
    })
  ];

  nativeBuildInputs = [
    cmake
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
