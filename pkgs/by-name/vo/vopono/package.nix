{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vopono";
  version = "0.10.21";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-JGzTebfh1cFPSy4+pkQRFop7wIxsogHVUAG7M7sHvOs=";
  };

  cargoHash = "sha256-I9pQ6hktej+zc4cKFfkxBQewUljG/g1/B8RkMuCTsjM=";

  meta = {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "vopono";
  };
})
