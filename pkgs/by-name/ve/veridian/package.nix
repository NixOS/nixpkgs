{
  lib,
  rustPlatform,
  fetchFromGitHub,

  cmake,
  makeWrapper,
  pkg-config,

  boost,
  fmt_11,
  openssl,
  sv-lang,
  mimalloc,

  verible,
  verilator,
}:
rustPlatform.buildRustPackage {
  pname = "veridian";
  version = "0-unstable-2024-12-25";

  src = fetchFromGitHub {
    owner = "vivekmalneedi";
    repo = "veridian";
    rev = "d094c9d2fa9745b2c4430eef052478c64d5dd3b6";
    hash = "sha256-3KjUunXTqdesvgDSeQMoXL0LRGsGQXZJGDt+xLWGovM=";
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
    fmt_11
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
