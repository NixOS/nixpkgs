{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wiremix";
  version = "0.9.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-gs6KqluASHTf4fURZKEmNvERguQEH5UDc4044uJddrU=";
  };

  cargoHash = "sha256-WqC+JVjE0zxvn9/64eGmMIwSqIBXj/OsEmvUHnGKEkA=";

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
