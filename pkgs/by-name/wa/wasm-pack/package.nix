{
  lib,
  fetchFromGitHub,
  rustPlatform,
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
    tag = "v${version}";
    hash = "sha256-CN1LcLX7ag+in9sosT2NYVKfhDLGv2m3zHOk2T4MFYc=";
  };

  cargoHash = "sha256-nYWvk2v+4IAk/y7fg+Z/nMH+Ml+J5k5ER8uudCQOMB8=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ zstd ];

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
