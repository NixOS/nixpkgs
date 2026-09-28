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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "wasm-bindgen";
    repo = "wasm-pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+M59AC/dz8WwK9+854QZjSPuikTW+x6Nx2FKnr7qiXs=";
  };

  cargoHash = "sha256-u8LFx2D9LDa9W/ghRWZ9N/vOBr0bAkTdnZt9YaKrD30=";

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
