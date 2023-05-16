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
<<<<<<< HEAD
  version = "4.0.0";
=======
  version = "3.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-vpIvoKvIqXgJ6MtuqM3dryR8nxLB/diLyQYcuGkZDLU=";
  };

  cargoHash = "sha256-1Gx8MLPAA/LV9jdK8gkztcsjltju0ousETLEiTEAaEo=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];
=======
    hash = "sha256-797I3FBBfnAgNfOdMajm3WNkMo3MUXb1347LBggXrLk=";
  };

  cargoHash = "sha256-zUTwhfRLKUixgj3JXiz2QOuwbFhfget+GcFSRL1QJ3w=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals withLLVM [
    llvmPackages.llvm
    libffi
    libxml2
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    SystemConfiguration
    Security
  ];

<<<<<<< HEAD
  # check references to `compiler_features` in Makefile on update
  buildFeatures = [
=======
  LLVM_SYS_120_PREFIX = lib.optionalString withLLVM llvmPackages.llvm.dev;

  # check references to `compiler_features` in Makefile on update
  buildFeatures = checkFeatures ++ [
    "webc_runner"
  ];

  checkFeatures = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "cranelift"
    "wasmer-artifact-create"
    "static-artifact-create"
    "wasmer-artifact-load"
    "static-artifact-load"
  ]
  ++ lib.optional withLLVM "llvm"
  ++ lib.optional withSinglepass "singlepass";

  cargoBuildFlags = [ "--manifest-path" "lib/cli/Cargo.toml" "--bin" "wasmer" ];

<<<<<<< HEAD
  env.LLVM_SYS_140_PREFIX = lib.optionalString withLLVM llvmPackages.llvm.dev;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
