{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage rec {
  pname = "wiremix";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LtwKG3phUuNgwXlAJMhZkOenYHGyXGRhNcr6+WKxVz0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Qc+VubikiYox1zqy2HO3InRI8aFT8AorrFZBQhNGFOQ=";

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
