{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-component-ld";
  version = "0.5.30";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-component-ld";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Fg80rVPaPC7IOvaj+FecXY9Tmn9WiseiRMkO70TQ/0=";
  };

  cargoHash = "sha256-jMI8XHQAfs/nzOLssz9+EqWCTkhv7qxIA5r9SH1Zx1c=";

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
