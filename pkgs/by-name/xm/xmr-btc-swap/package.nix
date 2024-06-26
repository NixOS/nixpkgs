{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "xmr-btc-swap";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "comit-network";
    repo = "xmr-btc-swap";
    rev = version;
    hash = "sha256-vR4Xu+GmEC18QHhu+20pQIjKUD/WFk4q0CuHXRINGxY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bitcoin-harness-0.2.1" = "sha256-enRFvcZKHZuchIYPrsKIPujMEwrzwErMN4P0vobVRl4=";
      "jsonrpc_client-0.7.1" = "sha256-avWNDE6O7Afhqd2OiWD23I7gSHhVRVg3WREyGpgrUaU=";
      "monero-0.12.0" = "sha256-HBtA7FhrvFOOTv48UK5yMuQV4etc8ULQA0L9KZNfakI=";
    };
  };

  postPatch = ''
    rm swap/build.rs
  '';

  nativeBuildInputs = [ protobuf ];

  env.VERGEN_GIT_DESCRIBE = version;

  doCheck = false; # The test requires docker and network

  meta = with lib; {
    description = "Bitcoin–Monero Cross-chain Atomic Swap";
    homepage = "https://github.com/comit-network/xmr-btc-swap";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ linsui ];
  };
}
