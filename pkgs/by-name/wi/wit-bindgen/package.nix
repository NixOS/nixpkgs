{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wit-bindgen";
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/48oa9Jby6Bp7aVHgU1DLSXeH52RG0wB7nvqbMf7uOg=";
  };

  cargoHash = "sha256-Cp8tNqk7sc3dqcAmaF3byCCzZc1i4Qk8d7eJ8v2SbIY=";

  # Some tests fail because they need network access to install the `wasm32-unknown-unknown` target.
  # However, GitHub Actions ensures a proper build.
  # See also:
  #   https://github.com/bytecodealliance/wit-bindgen/actions
  #   https://github.com/bytecodealliance/wit-bindgen/blob/main/.github/workflows/main.yml
  doCheck = false;

  meta = {
    description = "Language binding generator for WebAssembly interface types";
    homepage = "https://github.com/bytecodealliance/wit-bindgen";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "wit-bindgen";
  };
})
