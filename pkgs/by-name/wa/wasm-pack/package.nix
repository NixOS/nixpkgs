{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  cmake,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-pack";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "refs/tags/v${version}";
    hash = "sha256-CN1LcLX7ag+in9sosT2NYVKfhDLGv2m3zHOk2T4MFYc=";
  };

  cargoHash = "sha256-RdBnW8HKSgjVnyafycGFTSTc5j1A9WRDvUuZu8upRWY=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security ++ [
    zstd
  ];

  # Most tests rely on external resources and build artifacts.
  # Disabling check here to work with build sandboxing.
  doCheck = false;

  meta = with lib; {
    description = "Utility that builds rust-generated WebAssembly package";
    mainProgram = "wasm-pack";
    homepage = "https://github.com/rustwasm/wasm-pack";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ maintainers.dhkl ];
  };
}
