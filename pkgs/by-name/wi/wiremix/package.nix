{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  pipewire,
}:

rustPlatform.buildRustPackage rec {
  pname = "wiremix";
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7O8B45ZJr0QDRnbcu4nV4kbH8hCz+tUbjyy2KDMUr3o=";
  };

  cargoHash = "sha256-Wb697rtP0s/eua69mDawT6/ZaxwjxmwuxZMgrrM2Vsg=";

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
