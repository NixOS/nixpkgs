{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage rec {
  pname = "wiremix";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oxr2S02NiHY0fqYH8priqLg1baSRAMpEJov4Koiic/M=";
  };

  cargoHash = "sha256-KdpWF6WVOJzKvSjCz+XdCSVxd465R8iOK3aFUnSczvU=";

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
