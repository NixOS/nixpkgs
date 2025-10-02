{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl,
  fetchurl,
}:

let
  wasiPreviewCommandComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v22.0.0/wasi_snapshot_preview1.command.wasm";
    hash = "sha256-UVBFddlI0Yh1ZNs0b2jSnKsHvGGAS5U09yuwm8Q6lxw=";
  };
  wasiPreviewReactorComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v22.0.0/wasi_snapshot_preview1.reactor.wasm";
    hash = "sha256-oE53IRMZgysSWT7RhrpZJjdaIyzCRf0h4d1yjqj/PSk=";
  };

in
rustPlatform.buildRustPackage rec {
  pname = "wash-cli";
  version = "0.39.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-qOxYBhwkcn4g1cUBHuF0AoecpxN4ukgTjBnzVhWtw7A=";
  };

  cargoHash = "sha256-dPHzRZh5jBxbPt+1a9wVbsBclAkfrcAXhpZgTw7e4Qo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  preBuild = "
    export WASI_PREVIEW1_COMMAND_COMPONENT_ADAPTER=${wasiPreviewCommandComponentAdapter}
    export WASI_PREVIEW1_REACTOR_COMPONENT_ADAPTER=${wasiPreviewReactorComponentAdapter}
  ";

  # Tests require the internet and don't work when running in nix
  doCheck = false;

  meta = with lib; {
    description = "wasmCloud Shell (wash) CLI tool";
    homepage = "https://wasmcloud.com/";
    mainProgram = "wash";
    license = licenses.asl20;
    maintainers = with maintainers; [ bloveless ];
  };
}
