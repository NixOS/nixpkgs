{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, llvmPackages
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = version;
    sha256 = "0ciia8hhkkyh6rmrxgbk3bgwjwzkcba6645wlcm0vlgk2w4i5m3z";
    fetchSubmodules = true;
  };

  cargoSha256 = "140bzxhsyfif99x5a1m1d45ppb6jzvy9m4xil7z1wg2pnq9k7zz8";

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
    "--features" "test-cranelift,test-jit"
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
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
