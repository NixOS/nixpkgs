{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, llvmPackages
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = version;
    sha256 = "191f60db2y1f3xw1x81mw88vclf1c4kgvnfv74g5vb3vn7n57c5j";
    fetchSubmodules = true;
  };

  cargoSha256 = "0hhwixqhrl79hpzmvq7ga3kp2cfrwr4i8364cwnr7195xwnfxb0k";

  nativeBuildInputs = [ cmake pkg-config ];

  cargoBuildFlags = [
    # cranelift+jit works everywhere, see:
    # https://github.com/wasmerio/wasmer/blob/master/Makefile#L22
    "--features" "cranelift,jit"
    # must target manifest and desired output bin, otherwise output is empty
    "--manifest-path" "lib/cli/Cargo.toml"
    "--bin" "wasmer"
  ];

  cargoTestFlags = [
    "--features" "test-cranelift"
    # Can't use test-jit :
    # error: Package `wasmer-workspace v2.0.0 (/build/source)` does not have the feature `test-jit`
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

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
