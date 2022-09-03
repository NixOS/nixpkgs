{ stdenv
, lib
, rustPlatform
, libffi
, libxml2
, ncurses
, zlib
, fetchFromGitHub
, cmake
, llvmPackages_12 # See version specified in https://github.com/wasmerio/wasmer/tree/master/lib/compiler-llvm#requirements
, llvmPackages
, pkg-config
# See matrix https://github.com/wasmerio/wasmer/blob/master/Makefile#L22
, withLlvmCompiler ? ((stdenv.isDarwin || stdenv.isLinux) && stdenv.isx86_64)
, withSinglepassCompiler ? ((stdenv.isDarwin || stdenv.isLinux) && stdenv.isx86_64)
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = version;
    sha256 = "sha256-25wWgMNybbsEf/1xmm+8BPcjx8CSW9ZBzxGKT/DbBXw=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-tswsbijNN5UcSZovVmy66yehcEOpQDGMdRgR/1mkuE8=";

  buildInputs = [] ++ lib.optionals withLlvmCompiler [ libffi libxml2 ncurses zlib ];
  nativeBuildInputs = [ cmake pkg-config ] ++ lib.optionals withLlvmCompiler [ llvmPackages_12.llvm ];

  # cranelift+jit works everywhere, see:
  # https://github.com/wasmerio/wasmer/blob/master/Makefile#L22
  buildFeatures = [ "cranelift" "jit" ]
    ++ lib.optionals withLlvmCompiler [ "llvm" ]
    ++ lib.optionals withSinglepassCompiler [ "singlepass" ];
  cargoBuildFlags = [
    # must target manifest and desired output bin, otherwise output is empty
    "--manifest-path" "lib/cli/Cargo.toml"
    "--bin" "wasmer"
  ];

  # Can't use test-jit:
  # error: Package `wasmer-workspace v2.3.0 (/build/source)` does not have the feature `test-jit`
  checkFeatures = [ "test-cranelift" ];

  # Using llvmPackages_12 makes the test wast::spec::unreachable::cranelift::universal fail on aarch64
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  meta = with lib; {
    broken = stdenv.isDarwin;
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
