{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xq";
  version = "0.5.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-kgOwTQ+t5dhhb+MrilBZ5E7Ge3U6dllUpJ2I1fCX+jc=";
  };

  cargoHash = "sha256-xQ650Yx+lk+UKIHrad48eWUB/TUHeutL6tSrYwV0Eeg=";

  meta = {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
})
