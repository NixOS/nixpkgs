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
, withLLVM ? !stdenv.hostPlatform.isDarwin
, withSinglepass ? !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64)
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hEhU3o/SLHWV9zmgCtW+7K/2ev+oGAnrZmlyNtoeSV4=";
  };

  cargoHash = "sha256-xyR5pnwMGE5K4o7X0Q2JEervSgR5LK1vqpOa3Mm6xkU=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals withLLVM [
    llvmPackages.llvm
    libffi
    libxml2
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    description = "Universal WebAssembly Runtime";
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
