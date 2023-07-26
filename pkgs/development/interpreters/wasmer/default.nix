{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, llvmPackages
, libffi
, libxml2
, CoreFoundation
, SystemConfiguration
, Security
, withLLVM ? !stdenv.isDarwin
, withSinglepass ? !(stdenv.isDarwin && stdenv.isx86_64)
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vpIvoKvIqXgJ6MtuqM3dryR8nxLB/diLyQYcuGkZDLU=";
  };

  cargoHash = "sha256-1Gx8MLPAA/LV9jdK8gkztcsjltju0ousETLEiTEAaEo=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals withLLVM [
    llvmPackages.llvm
    libffi
    libxml2
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    SystemConfiguration
    Security
  ];

  # check references to `compiler_features` in Makefile on update
  buildFeatures = [
    "cranelift"
    "wasmer-artifact-create"
    "static-artifact-create"
    "wasmer-artifact-load"
    "static-artifact-load"
  ]
  ++ lib.optional withLLVM "llvm"
  ++ lib.optional withSinglepass "singlepass";

  cargoBuildFlags = [ "--manifest-path" "lib/cli/Cargo.toml" "--bin" "wasmer" ];

  env.LLVM_SYS_140_PREFIX = lib.optionalString withLLVM llvmPackages.llvm.dev;

  meta = with lib; {
    description = "The Universal WebAssembly Runtime";
    longDescription = ''
      Wasmer is a standalone WebAssembly runtime for running WebAssembly outside
      of the browser, supporting WASI and Emscripten. Wasmer can be used
      standalone (via the CLI) and embedded in different languages, running in
      x86 and ARM devices.
    '';
    homepage = "https://wasmer.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne shamilton ];
  };
}
