{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, darwin, fetchurl }:

let
  wasiPreviewCommandComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v21.0.1/wasi_snapshot_preview1.command.wasm";
    hash = "sha256-Dr/vQlMF8h79vAMtwuAtq6vII1h94kcUdaSspFIsbKY=";
  };
  wasiPreviewReactorComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v21.0.1/wasi_snapshot_preview1.reactor.wasm";
    hash = "sha256-NWumxeKoUt8HlwVJSVAbnlH9XGyOZGoNo6gJbRi+xRo=";
  };

in rustPlatform.buildRustPackage rec {
  pname = "wash-cli";
  version = "0.28.1";

  src = fetchCrate {
    inherit version pname;
      hash = "sha256-sEMOINkoYBR2E3QO8Ri28TshlqZSzSVDVKavv+jCiZg=";
  };

  cargoHash = "sha256-8ftRSi2kWexD4Ltr8WejFuHdrcrgYPs0ion9/0PC0A0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
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
