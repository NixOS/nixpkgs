{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-component-ld";
  version = "0.5.25";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-component-ld";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EQqNm3GRuMafbrOyzsdZ5e1pX4LH40wCyKVgSgm8A48=";
  };

  cargoHash = "sha256-1e54TLWGjfNORwr6uLIe/XhdDDOkbalw/6/0UGuBiPk=";

  # Tests require a rustc that can target wasm32-wasip1, including std. This is awkward for
  # Nixpkgs to provide at the same time as providing a rustc that's targetting the actual target.
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
