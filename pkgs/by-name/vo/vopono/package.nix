{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vopono";
  version = "0.10.18";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-qke5wYRpiqpV1dOZDApPZYYWWn2owokfa3ly+imhbzM=";
  };

  cargoHash = "sha256-GxzEOdsHJUa3LQKvtR/ZmOnBPaHOSMk0Qwqx7fikr1U=";

  meta = {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "vopono";
  };
})
