{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, nodejs
, jq
, llvmPackages
, libffi
, libxml2
, CoreFoundation
, SystemConfiguration
, Security
, withLLVM ? !stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "wasmer";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t/ObsvUSNGFvHkVH2nl8vLFI+5GUQx6niCgeH4ykk/0=";
  };

  patches = [
    # Use cargo read-manifest instead of pkgid to get package version
    # https://github.com/wasmerio/wasmer/pull/3380
    (fetchpatch {
      url = "https://github.com/wasmerio/wasmer/commit/f2118b3aefe73af20c447e71fa9ca50ffaf96018.patch";
      hash = "sha256-4HkjlVKWjkM3UT6UhZlXLgJYmwlIaJr8fVyOFvIckYE=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-wXVHxEPmHPeRnNytxl7bghxEp/WYOqAKMt5OCpxGcOA=";
  };

  nativeBuildInputs = [
    nodejs
    jq
  ] ++ (with rustPlatform; [
    rust.rustc
    rust.cargo
    cargoSetupHook
    bindgenHook
  ]);

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

  makeFlags = [
    "DESTDIR=$(out)"
    "WASMER_INSTALL_PREFIX=$(out)"
    "ENABLE_LLVM=${builtins.toString withLLVM}"
  ];

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
