{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, darwin, fetchurl }:

let
  wasiPreviewCommandComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v22.0.0/wasi_snapshot_preview1.command.wasm";
    hash = "sha256-UVBFddlI0Yh1ZNs0b2jSnKsHvGGAS5U09yuwm8Q6lxw=";
  };
  wasiPreviewReactorComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v22.0.0/wasi_snapshot_preview1.reactor.wasm";
    hash = "sha256-oE53IRMZgysSWT7RhrpZJjdaIyzCRf0h4d1yjqj/PSk=";
  };

in rustPlatform.buildRustPackage rec {
  pname = "wash-cli";
  version = "0.29.2";

  src = fetchCrate {
    inherit version pname;
      hash = "sha256-A66KSDYFbByguhnlzzU5nf8pE3lhnYQjI3h73SKB2Zo=";
  };

  cargoHash = "sha256-2mo30xHQ3aCExdI0ITDY9g/C5peN48PdUNFVVxM//+c=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
      darwin.apple_sdk.frameworks.CoreServices
    ];

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
