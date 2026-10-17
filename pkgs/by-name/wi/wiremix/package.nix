{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wiremix";
  version = "0.11.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-aV/HTDw5lKzcA8Q+IziHEFlIu8OpL9eUvjNuvqoz3SQ=";
  };

  cargoHash = "sha256-QT96vzK0PirBn4nf40SEghcbAt+aRplETUREONZtY3I=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [ pipewire ];

  meta = {
    description = "Simple TUI mixer for PipeWire";
    mainProgram = "wiremix";
    homepage = "https://github.com/tsowell/wiremix";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ tsowell ];
    platforms = lib.platforms.linux;
  };
})
