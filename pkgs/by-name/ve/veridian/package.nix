{
  lib,
  rustPlatform,
  fetchFromGitHub,

  cmake,
  makeWrapper,
  pkg-config,

  boost,
  fmt,
  openssl,
  sv-lang,
  mimalloc,

  verible,
  verilator,
}:
rustPlatform.buildRustPackage {
  pname = "veridian";
  version = "0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "vivekmalneedi";
    repo = "veridian";
    rev = "0c5776a4a4e08fd00b90d91ad3cd2ec10315d2bd";
    hash = "sha256-TQ1qyKQesk0eOArhvfGxOHtIwpyM7iUOgNI1VA1riPE=";
  };

  cargoHash = "sha256-qJQD9HjSrrHdppbLNgLnXCycgzbmPePydZve3A8zGtU=";

  buildFeatures = [ "slang" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    boost
    fmt
    openssl
    sv-lang
    mimalloc
  ];

  # the tests also need these to be on the PATH
  nativeCheckInputs = [
    verible
    verilator
  ];

  postInstall =
    let
      runtimePathDeps = [
        verible
        verilator
      ];
    in
    ''
      wrapProgram $out/bin/veridian \
        --prefix PATH : ${lib.makeBinPath runtimePathDeps}
    '';

  env = {
    OPENSSL_NO_VENDOR = "1";
    RUSTFLAGS = "-C link-args=-lmimalloc";
    # this is needed so that veridian doesn't try to build the sv-lang package itself
    SLANG_INSTALL_PATH = sv-lang;
  };

  meta = {
    description = "SystemVerilog Language Server";
    homepage = "https://github.com/vivekmalneedi/veridian";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hakan-demirli ];
  };
}
