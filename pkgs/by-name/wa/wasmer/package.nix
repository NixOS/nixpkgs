{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  llvmPackages_18,
  libffi,
  libxml2,
  withLLVM ?
    stdenv.hostPlatform.isLinux || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64),
}:

stdenv.mkDerivation rec {
  pname = "wasmer";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer";
    tag = "v${version}";
    hash = "sha256-nw/4hcEDkAabcpatVBRozxvVLzYOKbj3ylrGeQtNzMQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Nui8KxDk4+sqcmzeoZ6hGRb9Ux71+Nckz8seqq07cdE=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals withLLVM [
    llvmPackages_18.llvm
    libffi
    libxml2
  ];

  makeFlags = [
    "WASMER_INSTALL_PREFIX=${placeholder "out"}"
    "DESTDIR=${placeholder "out"}"
  ];

  buildFlags = [
    "ENABLE_LLVM=${if withLLVM then "1" else "0"}"
  ];

  env = lib.optionalAttrs withLLVM {
    LLVM_SYS_180_PREFIX = llvmPackages_18.llvm.dev;
  };

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
