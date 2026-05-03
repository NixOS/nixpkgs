{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-pack";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "wasm-bindgen";
    repo = "wasm-pack";
    tag = "v${finalAttrs.version}";
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
    changelog = "https://github.com/wasm-bindgen/wasm-pack/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Utility that builds rust-generated WebAssembly package";
    mainProgram = "wasm-pack";
    homepage = "https://github.com/wasm-bindgen/wasm-pack";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      dhkl
      hythera
    ];
  };
})
