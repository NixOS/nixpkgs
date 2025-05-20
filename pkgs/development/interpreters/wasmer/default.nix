{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages,
  libffi,
  libxml2,
  makeWrapper,
  bash,
  make,
  withLLVM ? true,
  withSinglepass ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Qx5bHCzdh3RqB5r93sa01mPyxN2EQWPWcIXJs1MrUHs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/Kcd9vZu5QstIEjDYaJ/ddXUIXL1F8Omi+Bm4jtOKcg=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    makeWrapper
    bash
    make
  ];

  buildInputs = lib.optionals withLLVM [
    llvmPackages.llvm
    libffi
    libxml2
  ];

  # check references to `compiler_features` in Makefile on update
  buildFeatures =
    [
      "cranelift"
      "wasmer-artifact-create"
      "static-artifact-create"
      "wasmer-artifact-load"
      "static-artifact-load"
    ]
    ++ lib.optional withLLVM "llvm"
    ++ lib.optional withSinglepass "singlepass";

  cargoBuildFlags = [
    "--manifest-path"
    "lib/cli/Cargo.toml"
    "--bin"
    "wasmer"
  ];

  env.LLVM_SYS_180_PREFIX = lib.optionalString withLLVM llvmPackages.llvm.dev;

  # Tests are failing due to `Cannot allocate memory` and other reasons
  doCheck = false;

  postBuild = ''
    # Prepare and build the Wasmer C-API
    sed -i 's|SHELL=/usr/bin/env bash|SHELL=${bash}/bin/bash|' Makefile
    make build-capi
    make package-capi
  '';

  postInstall = ''
    # Install the C-API headers, libs, etc.
    cp -r package/* $out/

    # Ensure the CLI can locate its assets
    makeWrapper "$out/bin/wasmer" \
      --set WASMER_DIR "$out"
  '';

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
