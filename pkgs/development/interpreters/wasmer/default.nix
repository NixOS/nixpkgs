{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages,
  libffi,
  libxml2,
  withLLVM ? true,
  withSinglepass ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZqaEArPnmaVh0fymtYZfxHnt8sm3FXsvc5kHH8GEDxM=";
  };

  cargoHash = "sha256-VCBwj5w7pXc1T+NlLVHTBhcsSRFfaxx9tZk3MFwsze4=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals withLLVM [
    llvmPackages.llvm
    libffi
    libxml2
  ];

  # check references to `compiler_features` in Makefile on update
  buildFeatures =
    [
      "cranelift"
      "wasmer-artifact-create"
      "static-artifact-create"
      "wasmer-artifact-load"
      "static-artifact-load"
    ]
    ++ lib.optional withLLVM "llvm"
    ++ lib.optional withSinglepass "singlepass";

  cargoBuildFlags = [
    "--manifest-path"
    "lib/cli/Cargo.toml"
    "--bin"
    "wasmer"
  ];

  env.LLVM_SYS_180_PREFIX = lib.optionalString withLLVM llvmPackages.llvm.dev;

  # Tests are failing due to `Cannot allocate memory` and other reasons
  doCheck = false;

  meta = {
    description = "Universal WebAssembly Runtime";
    mainProgram = "wasmer";
    longDescription = ''
      Wasmer is a standalone WebAssembly runtime for running WebAssembly outside
      of the browser, supporting WASI and Emscripten. Wasmer can be used
      standalone (via the CLI) and embedded in different languages, running in
      x86 and ARM devices.
    '';
    homepage = "https://wasmer.io/";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      shamilton
      nickcao
    ];
  };
}
