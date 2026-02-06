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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    tag = "v${version}";
    hash = "sha256-ik6AJUKuT3GCDTZbHWcplcB7cS0CIcZwFNa6SvGzsIQ=";
  };

  cargoHash = "sha256-n9xuwlj8+3fDTHMS2XobqWFc6mNHQcmmvebRDc82oSo=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ zstd ];

  # Most tests rely on external resources and build artifacts.
  # Disabling check here to work with build sandboxing.
  doCheck = false;

  meta = {
    description = "Utility that builds rust-generated WebAssembly package";
    mainProgram = "wasm-pack";
    homepage = "https://github.com/rustwasm/wasm-pack";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.dhkl ];
  };
}
