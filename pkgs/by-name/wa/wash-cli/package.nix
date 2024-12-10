{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl,
  darwin,
  fetchurl,
}:

let
  wasiPreviewCommandComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v13.0.0/wasi_snapshot_preview1.command.wasm";
    hash = "sha256-QihT0Iaq9VJs2mLL9CdS32lVMtDc9M952k/ZZ4tO6qs=";
  };
  wasiPreviewReactorComponentAdapter = fetchurl {
    url = "https://github.com/bytecodealliance/wasmtime/releases/download/v13.0.0/wasi_snapshot_preview1.reactor.wasm";
    hash = "sha256-bNmx/IqYPkA7YHvlYvHPmIMF/fkKtSXlZx1bjR3Neow=";
  };

in
rustPlatform.buildRustPackage rec {
  pname = "wash-cli";
  version = "0.24.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-exhN+44Sikcn2JiIry/jHOpYrPG2oQOpwq/Mq+0VK0U=";
  };

  cargoHash = "sha256-eEfkMoi4BPpKWkiTshHj59loFPzyrhFN/S8HKdMCGFM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
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
