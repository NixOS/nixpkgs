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
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-797I3FBBfnAgNfOdMajm3WNkMo3MUXb1347LBggXrLk=";
  };

  cargoHash = "sha256-zUTwhfRLKUixgj3JXiz2QOuwbFhfget+GcFSRL1QJ3w=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals withLLVM [
    llvmPackages.llvm
    libffi
    libxml2
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    SystemConfiguration
    Security
  ];

  LLVM_SYS_120_PREFIX = lib.optionalString withLLVM llvmPackages.llvm.dev;

  # check references to `compiler_features` in Makefile on update
  buildFeatures = checkFeatures ++ [
    "webc_runner"
  ];

  checkFeatures = [
    "cranelift"
    "wasmer-artifact-create"
    "static-artifact-create"
    "wasmer-artifact-load"
    "static-artifact-load"
  ]
  ++ lib.optional withLLVM "llvm"
  ++ lib.optional withSinglepass "singlepass";

  cargoBuildFlags = [ "--manifest-path" "lib/cli/Cargo.toml" "--bin" "wasmer" ];

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
