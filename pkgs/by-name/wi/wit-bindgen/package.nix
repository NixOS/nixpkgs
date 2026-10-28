{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wit-bindgen";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v//t+HSO1E4cNW2r6GadupDk9UItwq9lTOsLLg+ZKEA=";
  };

  cargoHash = "sha256-1kAH6evj8mc6mPUfKqhe4pT+gTI9DBQPegvxJ1YNsWQ=";

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
