{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vopono";
  version = "1.0.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-hYrA6A0pB8WW+/Q3gaBKBQ4pJp7kNvt+nRh66l14SRg=";
  };

  cargoHash = "sha256-vCHYYUXLhVZq09GPEBEtyumgJEMPqDTKuv7HIY65ToM=";

  meta = {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "vopono";
  };
})
