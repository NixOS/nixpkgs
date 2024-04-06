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
  version = "4.2.8";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HjEKC5Mnha+G2UFwAbFwx28qimSVY6aajTNjrOrPQFk=";
  };

  cargoHash = "sha256-CgD+0NfQibJS5x/snq9MdmUEx6sBlv07C/c1dcON3rQ=";

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

  env.LLVM_SYS_150_PREFIX = lib.optionalString withLLVM llvmPackages.llvm.dev;

  # Tests are failing due to `Cannot allocate memory` and other reasons
  doCheck = false;

  meta = with lib; {
    description = "The Universal WebAssembly Runtime";
    mainProgram = "wasmer";
    longDescription = ''
      Wasmer is a standalone WebAssembly runtime for running WebAssembly outside
      of the browser, supporting WASI and Emscripten. Wasmer can be used
      standalone (via the CLI) and embedded in different languages, running in
      x86 and ARM devices.
    '';
    homepage = "https://wasmer.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne shamilton nickcao ];
  };
}
