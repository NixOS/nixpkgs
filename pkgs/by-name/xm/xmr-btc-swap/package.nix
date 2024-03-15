{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "xmr-btc-swap";
  version = "0.12.3-unstable-2023-12-10";

  src = fetchFromGitHub {
    owner = "delta1";
    repo = pname;
    rev = "3c4eb799364837853a8dce33fbd94fbfabbe9228";
    hash = "sha256-57BBQWY33YclUj3+4ydTf6XE+rzU51qb34tKWAJeP7Q=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecdsa_fun-0.10.0" = "sha256-3fDGHoiQKsI91YSsLsU/2casDcFWpQR5cJKRW61xTV8=";
      "monero-0.12.0" = "sha256-HBtA7FhrvFOOTv48UK5yMuQV4etc8ULQA0L9KZNfakI=";
    };
  };

  postPatch = ''
    rm swap/build.rs
  '';

  nativeBuildInputs = [ protobuf ];

  env.VERGEN_GIT_DESCRIBE = version;
  doCheck = false;

  meta = with lib; {
    description = "Bitcoin–Monero Cross-chain Atomic Swap";
    homepage = "https://github.com/comit-network/xmr-btc-swap";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ linsui ];
  };
}


