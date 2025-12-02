{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage rec {
  pname = "wiremix";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wBE7gYR2fVbSc9NA8IGI2SGJwMACoPi1NTTdGq4UVF8=";
  };

  cargoHash = "sha256-0O8Oe4EppvvFIF9e0MzNSAGp0ZmnW3wr8DHw7G00UWY=";

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
}
