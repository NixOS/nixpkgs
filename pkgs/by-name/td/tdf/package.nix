{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
  glib,
  poppler,
  llvmPackages,
  clang,
}:

rustPlatform.buildRustPackage rec {
  pname = "tdf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    tag = "v${version}";
    hash = "sha256-YYsMLvhkLz1DNH4fhh1WZgEZr3eoy/7Oyz9hTw0jNaY=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-/Mr19iXVjuzzC9rIRk8nQP5jkDSMAgspNwwketO5v24=";

  nativeBuildInputs = [
    pkg-config
    clang
  ];

  buildInputs = [
    cairo
    glib
    poppler
  ];

  strictDeps = true;

  # No tests are currently present
  doCheck = false;

  env = {
    CFLAGS = "-Dfdopen=__fdopen";
    # requires nightly features (feature(portable_simd))
    RUSTC_BOOTSTRAP = 1;
    LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";
  };

  meta = {
    description = "Tui-based PDF viewer";
    homepage = "https://github.com/itsjunetime/tdf";
    license = with lib.licenses; [
      agpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      DieracDelta
    ];
    mainProgram = "tdf";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
