{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-pkg-tools";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-pkg-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VZ+rUZi6o2onMFxK/BMyi6ZjuDS0taJh5w3r33KCZTU=";
  };

  cargoHash = "sha256-dHhJT/edEYagLQoUcXCLPA4fUJdN9ZoOITLpWAH5p/0=";

  # Tests require internet and Docker, skipping for now.
  doCheck = false;

  meta = {
    description = "Tools to package up WebAssembly components";
    homepage = "https://github.com/bytecodealliance/wasm-pkg-tools";
    changelog = "https://github.com/bytecodealliance/wasm-pkg-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "wkg";
  };
})
