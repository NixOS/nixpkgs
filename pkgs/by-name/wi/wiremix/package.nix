{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage rec {
  pname = "wiremix";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8pXpbW6/XYiWUqulL8b+kGqhTa/X8+tkgL8EWguWs6c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-czhPbXkhuwUdwwP2uizU1Ob8t/x0nrJr3rquRO8Zktw=";

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
