{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
  glib,
}:
rustPlatform.buildRustPackage {
  pname = "tdf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    rev = "70b458207a79f565ae6f1fdd08d8861c94c67af2";
    hash = "sha256-YYsMLvhkLz1DNH4fhh1WZgEZr3eoy/7Oyz9hTw0jNaY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/Mr19iXVjuzzC9rIRk8nQP5jkDSMAgspNwwketO5v24=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    cairo
    glib
  ];

  strictDeps = true;

  # No tests are currently present
  doCheck = false;

  # requires nightly features (feature(portable_simd))
  RUSTC_BOOTSTRAP = true;

  meta = {
    description = "Tui-based PDF viewer";
    homepage = "https://github.com/itsjunetime/tdf";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      DieracDelta
    ];
    mainProgram = "tdf";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
