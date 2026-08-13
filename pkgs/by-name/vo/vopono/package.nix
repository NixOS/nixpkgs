{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vopono";
  version = "0.10.19";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-ZaDdW9V6SfALBVEg4UkXxpSL1bx6Zo5GJBaU9PhZqpc=";
  };

  cargoHash = "sha256-ezAmpzNZ8R6bDQxrzHsnjlXlKtJNPCRGF/yZJ/4dYyg=";

  meta = {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "vopono";
  };
})
