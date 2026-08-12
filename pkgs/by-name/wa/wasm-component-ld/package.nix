{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-component-ld";
  version = "0.5.29";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-component-ld";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YPQDSkNj1wXaZQUtQrailRIzLJ7+k2uvRLIDiD8oYpY=";
  };

  cargoHash = "sha256-CaZNS0RInbhCjrkydP2O1eeBZCpoKknEI5HaW/pJGrQ=";

  # Tests require a rustc that can target wasm32-wasip1, including std. This is awkward for
  # Nixpkgs to provide at the same time as providing a rustc that's targeting the actual target.
  # TODO: work around by patching the test suite to invoke pkgsBuildTarget.rustc rather than just looking in PATH for any old rustc
  doCheck = false;

  meta = {
    description = "Command line linker for creating WebAssembly components";
    homepage = "https://github.com/bytecodealliance/wasm-component-ld";
    license = with lib.licenses; [
      asl20
      llvm-exception
      mit
    ];
    maintainers = with lib.maintainers; [
      sepointon
    ];
    mainProgram = "wasm-component-ld";
  };
})
