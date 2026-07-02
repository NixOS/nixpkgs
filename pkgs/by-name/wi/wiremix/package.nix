{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wiremix";
  version = "0.10.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Ievr+xELhhWNYukqsiwv0WfCDRJqeCUdaZVeGsKQr2s=";
  };

  cargoHash = "sha256-vTLoNXZMlGnOvGHLWJVva09SuwXUSb4BHA61DZ7zSJk=";

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
